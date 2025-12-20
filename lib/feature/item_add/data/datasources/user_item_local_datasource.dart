import 'package:wedlist/core/services/hive_service.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_hive_model.dart';

abstract class UserItemLocalDataSource {
  Future<void> cacheUserItem(UserItemHiveModel item);
  Future<void> cacheUserItems(List<UserItemHiveModel> items);
  Future<UserItemHiveModel?> getUserItem(String id);
  Future<List<UserItemHiveModel>> getAllUserItems();
  Future<List<UserItemHiveModel>> getPendingSyncItems();
  Future<List<UserItemHiveModel>> getPendingDeleteItems();
  Future<void> updateUserItem(UserItemHiveModel item);
  Future<void> deleteUserItem(String id);
  Future<void> clearCache();
  Stream<List<UserItemHiveModel>> watchAllUserItems();
}

class UserItemLocalDataSourceImpl implements UserItemLocalDataSource {
  UserItemLocalDataSourceImpl(this.hiveService);
  final HiveService hiveService;

  @override
  Future<void> cacheUserItem(UserItemHiveModel item) async {
    final box = await hiveService.getUserItemsBox();
    await box.put(item.id, item);
  }

  @override
  Future<void> cacheUserItems(List<UserItemHiveModel> items) async {
    final box = await hiveService.getUserItemsBox();
    final itemsMap = {
      for (final item in items) item.id: item,
    };
    await box.putAll(itemsMap);
  }

  @override
  Future<UserItemHiveModel?> getUserItem(String id) async {
    final box = await hiveService.getUserItemsBox();
    return box.get(id);
  }

  @override
  Future<List<UserItemHiveModel>> getAllUserItems() async {
    final box = await hiveService.getUserItemsBox();
    return box.values.where((item) => !item.isPendingDelete).toList();
  }

  @override
  Future<List<UserItemHiveModel>> getPendingSyncItems() async {
    final box = await hiveService.getUserItemsBox();
    return box.values
        .where((item) => item.isPendingSync && !item.isPendingDelete)
        .toList();
  }

  @override
  Future<List<UserItemHiveModel>> getPendingDeleteItems() async {
    final box = await hiveService.getUserItemsBox();
    return box.values.where((item) => item.isPendingDelete).toList();
  }

  @override
  Future<void> updateUserItem(UserItemHiveModel item) async {
    final box = await hiveService.getUserItemsBox();
    await box.put(item.id, item);
  }

  @override
  Future<void> deleteUserItem(String id) async {
    final box = await hiveService.getUserItemsBox();
    await box.delete(id);
  }

  @override
  Future<void> clearCache() async {
    await hiveService.clearAllData();
  }

  @override
  Stream<List<UserItemHiveModel>> watchAllUserItems() async* {
    final box = await hiveService.getUserItemsBox();

    // Emit initial data
    yield box.values.where((item) => !item.isPendingDelete).toList();

    // Listen to changes
    yield* box.watch().map((_) {
      return box.values.where((item) => !item.isPendingDelete).toList();
    });
  }
}
