import 'package:wedlist/core/item/item_entity.dart';

abstract class ItemRepository {
  Future<ItemEntity?> fetchItemById(String id, {String? category});
}
