// ignore_for_file: public_member_api_docs

import 'package:wedlist/core/item/item_entity.dart';

abstract class WishListRepository {
  Future<List<ItemEntity>> getItems(String category, String langCode, String id);
  Future<void> addItems(String category, List<String> titles);
}
