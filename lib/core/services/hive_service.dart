import 'package:hive_flutter/hive_flutter.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_hive_model.dart';
import 'package:wedlist/feature/wishlist/data/models/wishlist_item_hive_model.dart';

class HiveService {
  static const String userItemsBoxName = 'user_items';
  static const String wishlistItemsBoxName = 'wishlist_items';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserItemHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WishlistItemHiveModelAdapter());
    }
  }

  Future<Box<UserItemHiveModel>> getUserItemsBox() async {
    if (!Hive.isBoxOpen(userItemsBoxName)) {
      return Hive.openBox<UserItemHiveModel>(userItemsBoxName);
    }
    return Hive.box<UserItemHiveModel>(userItemsBoxName);
  }

  Future<Box<WishlistItemHiveModel>> getWishlistItemsBox() async {
    if (!Hive.isBoxOpen(wishlistItemsBoxName)) {
      return Hive.openBox<WishlistItemHiveModel>(wishlistItemsBoxName);
    }
    return Hive.box<WishlistItemHiveModel>(wishlistItemsBoxName);
  }

  Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  Future<void> clearAllData() async {
    final userBox = await getUserItemsBox();
    await userBox.clear();

    final wishlistBox = await getWishlistItemsBox();
    await wishlistBox.clear();
  }
}
