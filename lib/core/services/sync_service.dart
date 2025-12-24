import 'dart:async';

import 'package:wedlist/core/services/network_info.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_local_datasource.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_remote_datasource.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_hive_model.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_model.dart';

class SyncService {
  SyncService({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.userModeService,
  });

  final UserItemLocalDataSource localDataSource;
  final UserItemRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UserModeService userModeService;

  Timer? _periodicSyncTimer;
  StreamSubscription<bool>? _connectivitySubscription;

  /// Start background sync
  /// - Periodic sync every 5 minutes
  /// - Connectivity-based sync when coming back online
  void startSync() {
    // 1. Periodic sync every 5 minutes
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => syncPendingItems(),
    );

    // 2. Sync when connectivity changes (offline -> online)
    _connectivitySubscription = networkInfo.onConnectivityChanged
        .where((isConnected) => isConnected)
        .listen((_) => syncPendingItems());
  }

  /// Stop background sync
  void stopSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Manually trigger sync
  Future<SyncResult> syncPendingItems() async {
    // Skip sync for offline users
    if (await userModeService.isOfflineMode()) {
      return SyncResult(
        success: false,
        reason: 'User in offline mode - sync disabled',
      );
    }

    if (!await networkInfo.isConnected) {
      return SyncResult(success: false, reason: 'No internet connection');
    }

    try {
      var syncedCount = 0;
      var failedCount = 0;

      // 1. Sync pending updates/creates
      final pendingItems = await localDataSource.getPendingSyncItems();
      for (final item in pendingItems) {
        try {
          // Check if item exists remotely (update vs create)
          final remoteItem = await remoteDataSource.fetchUserItemById(item.id);

          if (remoteItem != null) {
            // Update existing
            await remoteDataSource.updateUserItem(
              UserItemModel.fromEntity(item.toEntity()),
            );
          } else {
            // Create new
            await remoteDataSource.addUserItem(
              UserItemModel.fromEntity(item.toEntity()),
            );
          }

          // Mark as synced
          final syncedItem = UserItemHiveModel.fromEntity(
            item.toEntity().copyWith(
              isPendingSync: false,
              lastSyncedAt: DateTime.now(),
            ),
          );
          await localDataSource.updateUserItem(syncedItem);
          syncedCount++;
        } catch (e) {
          failedCount++;
          // Continue with next item
        }
      }

      // 2. Sync pending deletes
      final pendingDeletes = await localDataSource.getPendingDeleteItems();
      for (final item in pendingDeletes) {
        try {
          await remoteDataSource.deleteUserItem(item.id);

          // Hard delete from local
          await localDataSource.deleteUserItem(item.id);
          syncedCount++;
        } catch (e) {
          failedCount++;
          // Continue with next item
        }
      }

      return SyncResult(
        success: failedCount == 0,
        syncedCount: syncedCount,
        failedCount: failedCount,
        reason: failedCount > 0 ? 'Some items failed to sync' : null,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        reason: 'Sync failed: $e',
      );
    }
  }

  /// Full sync: Download all items from server and update local cache
  Future<SyncResult> fullSync() async {
    // Skip sync for offline users
    if (await userModeService.isOfflineMode()) {
      return SyncResult(
        success: false,
        reason: 'User in offline mode - full sync disabled',
      );
    }

    if (!await networkInfo.isConnected) {
      return SyncResult(success: false, reason: 'No internet connection');
    }

    try {
      // First sync any pending changes
      await syncPendingItems();

      // Then download all from server
      final remoteItems = await remoteDataSource.fetchAllUserItems();

      final localItems = remoteItems.map((model) {
        return UserItemHiveModel.fromEntity(
          model.toEntity().copyWith(
            isPendingSync: false,
            lastSyncedAt: DateTime.now(),
          ),
        );
      }).toList();

      await localDataSource.cacheUserItems(localItems);

      return SyncResult(
        success: true,
        syncedCount: localItems.length,
      );
    } on Exception catch (e) {
      return SyncResult(
        success: false,
        reason: 'Full sync failed: $e',
      );
    }
  }
}

class SyncResult {
  SyncResult({
    required this.success,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.reason,
  });

  final bool success;
  final int syncedCount;
  final int failedCount;
  final String? reason;

  @override
  String toString() {
    if (success) {
      return 'Sync successful: $syncedCount items synced';
    }
    return 'Sync failed: $reason (Synced: $syncedCount, Failed: $failedCount)';
  }
}
