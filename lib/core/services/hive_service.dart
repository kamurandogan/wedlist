import 'package:hive_flutter/hive_flutter.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_hive_model.dart';

class HiveService {
  static const String userItemsBoxName = 'user_items';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserItemHiveModelAdapter());
    }
  }

  Future<Box<UserItemHiveModel>> getUserItemsBox() async {
    if (!Hive.isBoxOpen(userItemsBoxName)) {
      return await Hive.openBox<UserItemHiveModel>(userItemsBoxName);
    }
    return Hive.box<UserItemHiveModel>(userItemsBoxName);
  }

  Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  Future<void> clearAllData() async {
    final box = await getUserItemsBox();
    await box.clear();
  }
}
