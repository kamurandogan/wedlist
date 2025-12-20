import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/services/network_info.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_local_datasource.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_remote_datasource.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_hive_model.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_model.dart';
import 'package:wedlist/feature/item_add/domain/repositories/user_item_repository.dart';

class UserItemRepositoryImplOffline implements UserItemRepository {
  UserItemRepositoryImplOffline({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final UserItemRemoteDataSource remoteDataSource;
  final UserItemLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Unit>> addUserItem(UserItemEntity item) async {
    try {
      // 1. Optimistic: Save locally first with pending sync flag
      final localItem = UserItemHiveModel.fromEntity(
        item.copyWith(isPendingSync: true),
      );
      await localDataSource.cacheUserItem(localItem);

      // 2. Try sync if online
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.addUserItem(UserItemModel.fromEntity(item));

          // Success: Mark as synced
          final syncedItem = UserItemHiveModel.fromEntity(
            item.copyWith(
              isPendingSync: false,
              lastSyncedAt: DateTime.now(),
            ),
          );
          await localDataSource.updateUserItem(syncedItem);
        } catch (_) {
          // Remote failed, but local saved - will sync later
        }
      }

      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserItemEntity?>> fetchUserItemById(String id) async {
    try {
      // 1. Read from local first (offline-first)
      final localItem = await localDataSource.getUserItem(id);

      // 2. Try to fetch fresh data if online
      if (await networkInfo.isConnected) {
        try {
          final remoteModel = await remoteDataSource.fetchUserItemById(id);
          if (remoteModel != null) {
            // Cache fresh data
            final freshItem = UserItemHiveModel.fromEntity(
              remoteModel.toEntity().copyWith(
                isPendingSync: false,
                lastSyncedAt: DateTime.now(),
              ),
            );
            await localDataSource.cacheUserItem(freshItem);
            return Right(freshItem.toEntity());
          }
        } catch (_) {
          // Remote failed, use local cache
        }
      }

      // Return local data (might be null)
      return Right(localItem?.toEntity());
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserItemEntity>>> fetchAllUserItems() async {
    try {
      // 1. Read from local first (immediate response)
      final localItems = await localDataSource.getAllUserItems();

      // 2. Try to sync with remote if online
      if (await networkInfo.isConnected) {
        try {
          final remoteModels = await remoteDataSource.fetchAllUserItems();

          // Cache all remote items
          final freshItems = remoteModels.map((model) {
            return UserItemHiveModel.fromEntity(
              model.toEntity().copyWith(
                isPendingSync: false,
                lastSyncedAt: DateTime.now(),
              ),
            );
          }).toList();

          await localDataSource.cacheUserItems(freshItems);

          return Right(freshItems.map((e) => e.toEntity()).toList());
        } catch (_) {
          // Remote failed, use local cache
        }
      }

      // Return local data
      return Right(localItems.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserItem(UserItemEntity item) async {
    try {
      // 1. Update locally first (optimistic)
      final localItem = UserItemHiveModel.fromEntity(
        item.copyWith(isPendingSync: true),
      );
      await localDataSource.updateUserItem(localItem);

      // 2. Try sync if online
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.updateUserItem(UserItemModel.fromEntity(item));

          // Success: Mark as synced
          final syncedItem = UserItemHiveModel.fromEntity(
            item.copyWith(
              isPendingSync: false,
              lastSyncedAt: DateTime.now(),
            ),
          );
          await localDataSource.updateUserItem(syncedItem);
        } catch (_) {
          // Remote failed, will sync later
        }
      }

      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUserItem(String id) async {
    try {
      // 1. Mark as pending delete locally (soft delete)
      final localItem = await localDataSource.getUserItem(id);
      if (localItem != null) {
        final deletedItem = UserItemHiveModel.fromEntity(
          localItem.toEntity().copyWith(
            isPendingDelete: true,
            isPendingSync: true,
          ),
        );
        await localDataSource.updateUserItem(deletedItem);
      }

      // 2. Try sync if online
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.deleteUserItem(id);

          // Success: Hard delete locally
          await localDataSource.deleteUserItem(id);
        } catch (_) {
          // Remote failed, will sync later
        }
      }

      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<List<UserItemEntity>> watchAllUserItems() {
    // Watch local data (real-time updates)
    return localDataSource.watchAllUserItems().map(
      (items) => items.map((e) => e.toEntity()).toList(),
    );
  }
}
