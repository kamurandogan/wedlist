import 'package:wedlist/core/services/hive_service.dart';
import 'package:wedlist/feature/wishlist/data/models/wishlist_item_hive_model.dart';

abstract class WishlistLocalDataSource {
  Future<void> cacheWishlistItem(WishlistItemHiveModel item);
  Future<void> cacheWishlistItems(List<WishlistItemHiveModel> items);
  Future<WishlistItemHiveModel?> getWishlistItem(String id);
  Future<List<WishlistItemHiveModel>> getAllWishlistItems();
  Future<List<WishlistItemHiveModel>> getPendingSyncItems();
  Future<List<WishlistItemHiveModel>> getPendingDeleteItems();
  Future<void> updateWishlistItem(WishlistItemHiveModel item);
  Future<void> deleteWishlistItem(String id);
  Future<void> clearCache();
  Stream<List<WishlistItemHiveModel>> watchAllWishlistItems();
}

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  WishlistLocalDataSourceImpl(this.hiveService);
  final HiveService hiveService;

  @override
  Future<void> cacheWishlistItem(WishlistItemHiveModel item) async {
    final box = await hiveService.getWishlistItemsBox();
    await box.put(item.id, item);
  }

  @override
  Future<void> cacheWishlistItems(List<WishlistItemHiveModel> items) async {
    final box = await hiveService.getWishlistItemsBox();
    final itemsMap = {
      for (final item in items) item.id: item,
    };
    await box.putAll(itemsMap);
  }

  @override
  Future<WishlistItemHiveModel?> getWishlistItem(String id) async {
    final box = await hiveService.getWishlistItemsBox();
    return box.get(id);
  }

  @override
  Future<List<WishlistItemHiveModel>> getAllWishlistItems() async {
    final box = await hiveService.getWishlistItemsBox();
    return box.values.where((item) => !item.isPendingDelete).toList();
  }

  @override
  Future<List<WishlistItemHiveModel>> getPendingSyncItems() async {
    final box = await hiveService.getWishlistItemsBox();
    return box.values
        .where((item) => item.isPendingSync && !item.isPendingDelete)
        .toList();
  }

  @override
  Future<List<WishlistItemHiveModel>> getPendingDeleteItems() async {
    final box = await hiveService.getWishlistItemsBox();
    return box.values.where((item) => item.isPendingDelete).toList();
  }

  @override
  Future<void> updateWishlistItem(WishlistItemHiveModel item) async {
    final box = await hiveService.getWishlistItemsBox();
    await box.put(item.id, item);
  }

  @override
  Future<void> deleteWishlistItem(String id) async {
    final box = await hiveService.getWishlistItemsBox();
    await box.delete(id);
  }

  @override
  Future<void> clearCache() async {
    final box = await hiveService.getWishlistItemsBox();
    await box.clear();
  }

  @override
  Stream<List<WishlistItemHiveModel>> watchAllWishlistItems() async* {
    final box = await hiveService.getWishlistItemsBox();

    // Emit initial data
    yield box.values.where((item) => !item.isPendingDelete).toList();

    // Listen to changes
    yield* box.watch().map((_) {
      return box.values.where((item) => !item.isPendingDelete).toList();
    });
  }
}
