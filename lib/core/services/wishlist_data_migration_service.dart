import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/data/models/wishlist_item_hive_model.dart';

class MigrationResult {
  MigrationResult({
    required this.success,
    this.migratedCount = 0,
    this.failedCount = 0,
    this.reason,
  });

  final bool success;
  final int migratedCount;
  final int failedCount;
  final String? reason;
}

class WishlistDataMigrationService {
  WishlistDataMigrationService({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final WishlistLocalDataSource localDataSource;
  final WishListRemoteDataSource remoteDataSource;

  /// Migrate offline wishlist data to authenticated user's Firebase account
  /// Called when user logs in after using offline mode
  Future<MigrationResult> migrateOfflineToAuthenticated(
    String langCode,
  ) async {
    try {
      AppLogger.info('Starting wishlist data migration...');

      // 1. Get all local wishlist items
      final offlineItems = await localDataSource.getAllWishlistItems();

      if (offlineItems.isEmpty) {
        AppLogger.info('No offline wishlist items to migrate');
        return MigrationResult(success: true);
      }

      // 2. Group items by category
      final itemsByCategory = <String, List<String>>{};
      for (final item in offlineItems) {
        itemsByCategory.putIfAbsent(item.category, () => []).add(item.title);
      }

      // 3. Upload each category to Firebase
      var migratedCount = 0;
      var failedCount = 0;

      for (final entry in itemsByCategory.entries) {
        try {
          await remoteDataSource.addItems(entry.key, entry.value);

          // Mark items as synced
          final itemsToUpdate = offlineItems
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
            migratedCount++;
          }

          AppLogger.info(
            'Migrated ${entry.value.length} items in category ${entry.key}',
          );
        } on Exception catch (e) {
          failedCount += entry.value.length;
          AppLogger.warning(
            'Failed to migrate category ${entry.key}',
            e,
          );
        }
      }

      final result = MigrationResult(
        success: failedCount == 0,
        migratedCount: migratedCount,
        failedCount: failedCount,
      );

      AppLogger.info(
        'Wishlist migration completed: '
        'migrated=$migratedCount, failed=$failedCount',
      );

      return result;
    } on Exception catch (e) {
      AppLogger.error('Wishlist migration failed', e);
      return MigrationResult(
        success: false,
        reason: e.toString(),
      );
    }
  }

  /// Clear local wishlist data after successful migration (optional)
  /// Use with caution - only call if you're sure migration succeeded
  Future<void> clearLocalDataAfterMigration() async {
    try {
      await localDataSource.clearCache();
      AppLogger.info('Local wishlist data cleared after migration');
    } on Exception catch (e) {
      AppLogger.warning('Failed to clear local wishlist data', e);
    }
  }
}
