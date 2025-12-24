import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/services/network_info.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/data/models/wishlist_item_hive_model.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';

class WishListRepositoryImplOffline implements WishListRepository {
  WishListRepositoryImplOffline({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.userModeService,
    required this.firestore,
  });

  final WishListRemoteDataSource remoteDataSource;
  final WishlistLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final UserModeService userModeService;
  final FirebaseFirestore firestore;
  final _uuid = const Uuid();

  /// Offline kullanıcılar için direkt Firestore'dan base items çek
  Future<List<ItemEntity>> _fetchBaseItemsForOffline(String langCode) async {
    final collection = 'items_${langCode.toUpperCase()}';
    AppLogger.info('Fetching base items from Firestore: $collection');

    final snapshot = await firestore.collection(collection).get();
    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      return ItemEntity(
        id: data['id'] as String? ?? doc.id,
        title: data['title'] as String,
        category: data['category'] as String,
      );
    }).toList();

    AppLogger.info('Fetched ${items.length} base items from $collection');
    return items;
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getItems(
    String category,
    String langCode,
    String id,
  ) async {
    try {
      final isOffline = await userModeService.isOfflineMode();

      // 1. Read from local first (immediate response)
      final localItems = await localDataSource.getAllWishlistItems();
      final filteredLocal = category.isEmpty
          ? localItems
          : localItems.where((item) => item.category == category).toList();

      // 2. Offline mode handling
      if (isOffline) {
        AppLogger.info(
          'WishlistRepo: Offline mode - localItems: ${localItems.length}, '
          'category: $category, langCode: $langCode',
        );

        // Eğer Hive boşsa ve internet varsa, ülkeye göre base items'ı çek
        if (localItems.isEmpty && await networkInfo.isConnected) {
          AppLogger.info(
            'WishlistRepo: Hive empty, fetching base items for langCode: $langCode',
          );
          try {
            // Offline kullanıcı için direkt Firestore'dan base items çek
            final baseItems = await _fetchBaseItemsForOffline(langCode);

            AppLogger.info(
              'WishlistRepo: Fetched ${baseItems.length} base items from Firebase',
            );

            // Base items'ı Hive'a kaydet (offline kullanıcı verisi)
            final itemsToCache = baseItems.map((entity) {
              return WishlistItemHiveModel.fromEntity(
                entity.copyWith(
                  isPendingSync: false, // Offline user, no sync needed
                  isPendingDelete: false,
                  lastSyncedAt: DateTime.now(),
                ),
              );
            }).toList();

            await localDataSource.cacheWishlistItems(itemsToCache);
            AppLogger.info(
              'WishlistRepo: Cached ${itemsToCache.length} items to Hive',
            );

            return Right(baseItems);
          } catch (e) {
            AppLogger.error('WishlistRepo: Failed to fetch base items', e);
            // Network error, return empty list for offline first launch
            return const Right([]);
          }
        }

        // Hive'da veri varsa, lokal veriyi dön
        AppLogger.info(
          'WishlistRepo: Returning ${filteredLocal.length} items from Hive cache',
        );
        return Right(filteredLocal.map((e) => e.toEntity()).toList());
      }

      // 3. Authenticated mode: Try remote sync
      if (await networkInfo.isConnected) {
        try {
          final remoteItems = await remoteDataSource.getItems(
            category,
            langCode,
            id,
          );

          // Cache all remote items
          final freshItems = remoteItems.map((entity) {
            return WishlistItemHiveModel.fromEntity(
              entity.copyWith(
                isPendingSync: false,
                isPendingDelete: false,
                lastSyncedAt: DateTime.now(),
              ),
            );
          }).toList();

          await localDataSource.cacheWishlistItems(freshItems);

          return Right(remoteItems);
        } catch (e) {
          // Remote failed, use local cache
        }
      }

      // 4. Return local data
      return Right(filteredLocal.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ItemEntity>>> getItemsStream(
    String category,
    String langCode,
    String id,
  ) async* {
    try {
      final isOffline = await userModeService.isOfflineMode();

      if (isOffline) {
        AppLogger.info(
          'WishlistRepo STREAM: Offline mode - category: $category, langCode: $langCode',
        );

        // Offline mode: First try to load base items if Hive is empty
        final localItems = await localDataSource.getAllWishlistItems();
        AppLogger.info(
          'WishlistRepo STREAM: Local items count: ${localItems.length}',
        );

        if (localItems.isEmpty && await networkInfo.isConnected) {
          AppLogger.info(
            'WishlistRepo STREAM: Hive empty & online, fetching base items...',
          );
          try {
            // Offline kullanıcı için direkt Firestore'dan base items çek
            final baseItems = await _fetchBaseItemsForOffline(langCode);

            AppLogger.info(
              'WishlistRepo STREAM: Fetched ${baseItems.length} base items',
            );

            // Cache base items
            final itemsToCache = baseItems.map((entity) {
              return WishlistItemHiveModel.fromEntity(
                entity.copyWith(
                  isPendingSync: false,
                  isPendingDelete: false,
                  lastSyncedAt: DateTime.now(),
                ),
              );
            }).toList();

            await localDataSource.cacheWishlistItems(itemsToCache);
            AppLogger.info('WishlistRepo STREAM: Cached to Hive');
          } catch (e) {
            AppLogger.error(
              'WishlistRepo STREAM: Failed to fetch base items',
              e,
            );
            // Network error, continue with empty local
          }
        }

        // Stream from local (now populated with base items if was empty)
        AppLogger.info('WishlistRepo STREAM: Streaming from Hive...');
        yield* localDataSource.watchAllWishlistItems().map((items) {
          final filtered = category.isEmpty
              ? items
              : items.where((item) => item.category == category).toList();
          AppLogger.info(
            'WishlistRepo STREAM: Yielding ${filtered.length} items',
          );
          return Right<Failure, List<ItemEntity>>(
            filtered.map((e) => e.toEntity()).toList(),
          );
        });
      } else {
        // Authenticated: Try remote stream, fallback to local
        if (await networkInfo.isConnected) {
          try {
            yield* remoteDataSource
                .getItemsStream(category, langCode, id)
                .map(
                  (remoteItems) {
                    // Cache in background
                    Future(() async {
                      final freshItems = remoteItems.map((entity) {
                        return WishlistItemHiveModel.fromEntity(
                          entity.copyWith(
                            isPendingSync: false,
                            isPendingDelete: false,
                            lastSyncedAt: DateTime.now(),
                          ),
                        );
                      }).toList();
                      await localDataSource.cacheWishlistItems(freshItems);
                    });

                    return Right<Failure, List<ItemEntity>>(remoteItems);
                  },
                )
                .handleError((dynamic error) {
                  // On remote error, fallback to local stream
                  return localDataSource.watchAllWishlistItems().map((items) {
                    final filtered = category.isEmpty
                        ? items
                        : items
                              .where((item) => item.category == category)
                              .toList();
                    return Right<Failure, List<ItemEntity>>(
                      filtered.map((e) => e.toEntity()).toList(),
                    );
                  });
                });
          } catch (_) {
            // Remote stream failed, use local
            yield* localDataSource.watchAllWishlistItems().map((items) {
              final filtered = category.isEmpty
                  ? items
                  : items.where((item) => item.category == category).toList();
              return Right<Failure, List<ItemEntity>>(
                filtered.map((e) => e.toEntity()).toList(),
              );
            });
          }
        } else {
          // No connection, use local
          yield* localDataSource.watchAllWishlistItems().map((items) {
            final filtered = category.isEmpty
                ? items
                : items.where((item) => item.category == category).toList();
            return Right<Failure, List<ItemEntity>>(
              filtered.map((e) => e.toEntity()).toList(),
            );
          });
        }
      }
    } on Exception catch (e) {
      yield Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addItems(
    String category,
    List<String> titles,
  ) async {
    try {
      final isOffline = await userModeService.isOfflineMode();

      // 1. Optimistic: Save locally first
      final hiveItems = titles.map((title) {
        return WishlistItemHiveModel(
          id: _uuid.v4(),
          title: title,
          category: category,
          isPendingSync: !isOffline, // Mark for sync if authenticated
        );
      }).toList();

      for (final item in hiveItems) {
        await localDataSource.cacheWishlistItem(item);
      }

      // 2. Try remote sync if authenticated and online
      if (!isOffline && await networkInfo.isConnected) {
        try {
          await remoteDataSource.addItems(category, titles);

          // Success: Mark as synced
          for (final item in hiveItems) {
            final syncedItem = WishlistItemHiveModel.fromEntity(
              item.toEntity().copyWith(
                isPendingSync: false,
                lastSyncedAt: DateTime.now(),
              ),
            );
            await localDataSource.updateWishlistItem(syncedItem);
          }
        } catch (_) {
          // Remote failed, but local saved - will sync later via SyncService
        }
      }

      return const Right(null);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
