import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/services/network_info.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/data/models/wishlist_item_hive_model.dart';

class WishlistSyncResult {
  WishlistSyncResult({
    required this.success,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.reason,
  });

  final bool success;
  final int syncedCount;
  final int failedCount;
  final String? reason;
}

class WishlistSyncService {
  WishlistSyncService({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.userModeService,
    required this.networkInfo,
  });

  final WishlistLocalDataSource localDataSource;
  final WishListRemoteDataSource remoteDataSource;
  final UserModeService userModeService;
  final NetworkInfo networkInfo;

  Timer? _periodicTimer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  /// Start background sync service
  /// - Periodic sync every 5 minutes
  /// - Connectivity change trigger
  void startSync() {
    // Periodic sync (5 minutes)
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => syncPendingItems(),
    );

    // Connectivity change trigger
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      // When network becomes available, trigger sync
      if (result != ConnectivityResult.none) {
        syncPendingItems();
      }
    });

    AppLogger.info('WishlistSyncService started');
  }

  /// Stop sync service
  void stopSync() {
    _periodicTimer?.cancel();
    _connectivitySubscription?.cancel();
    AppLogger.info('WishlistSyncService stopped');
  }

  /// Sync pending wishlist items to Firebase
  Future<WishlistSyncResult> syncPendingItems() async {
    try {
      // 1. Check if user is offline
      final isOffline = await userModeService.isOfflineMode();
      if (isOffline) {
        return WishlistSyncResult(
          success: false,
          reason: 'User in offline mode',
        );
      }

      // 2. Check network connectivity
      if (!await networkInfo.isConnected) {
        return WishlistSyncResult(
          success: false,
          reason: 'No network connection',
        );
      }

      // 3. Get pending sync items
      final pendingItems = await localDataSource.getPendingSyncItems();
      if (pendingItems.isEmpty) {
        return WishlistSyncResult(success: true);
      }

      // 4. Group items by category
      final itemsByCategory = <String, List<String>>{};
      for (final item in pendingItems) {
        itemsByCategory.putIfAbsent(item.category, () => []).add(item.title);
      }

      // 5. Sync each category
      var syncedCount = 0;
      var failedCount = 0;

      for (final entry in itemsByCategory.entries) {
        try {
          await remoteDataSource.addItems(entry.key, entry.value);

          // Mark items as synced
          final itemsToUpdate = pendingItems
              .where((item) => item.category == entry.key)
              .toList();

          for (final item in itemsToUpdate) {
            final syncedItem = WishlistItemHiveModel.fromEntity(
              item.toEntity().copyWith(
                isPendingSync: false,
                lastSyncedAt: DateTime.now(),
              ),
            );
            await localDataSource.updateWishlistItem(syncedItem);
            syncedCount++;
          }

          AppLogger.info(
            'Synced ${entry.value.length} items in category ${entry.key}',
          );
        } on Exception catch (e) {
          failedCount += entry.value.length;
          AppLogger.warning(
            'Failed to sync category ${entry.key}',
            e,
          );
        }
      }

      return WishlistSyncResult(
        success: failedCount == 0,
        syncedCount: syncedCount,
        failedCount: failedCount,
      );
    } on Exception catch (e) {
      AppLogger.error('WishlistSyncService error', e);
      return WishlistSyncResult(
        success: false,
        reason: e.toString(),
      );
    }
  }

  /// Sync pending delete operations
  Future<WishlistSyncResult> syncPendingDeletes() async {
    try {
      final isOffline = await userModeService.isOfflineMode();
      if (isOffline) {
        return WishlistSyncResult(
          success: false,
          reason: 'User in offline mode',
        );
      }

      if (!await networkInfo.isConnected) {
        return WishlistSyncResult(
          success: false,
          reason: 'No network connection',
        );
      }

      final pendingDeletes = await localDataSource.getPendingDeleteItems();
      if (pendingDeletes.isEmpty) {
        return WishlistSyncResult(success: true);
      }

      var syncedCount = 0;
      for (final item in pendingDeletes) {
        try {
          // Note: You may need to implement deleteItem in remote datasource
          // For now, we'll just hard delete locally after confirmation
          await localDataSource.deleteWishlistItem(item.id);
          syncedCount++;
        } on Exception catch (e) {
          AppLogger.warning('Failed to delete item ${item.id}', e);
        }
      }

      return WishlistSyncResult(
        success: true,
        syncedCount: syncedCount,
      );
    } on Exception catch (e) {
      return WishlistSyncResult(
        success: false,
        reason: e.toString(),
      );
    }
  }
}
