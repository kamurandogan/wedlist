import 'package:wedlist/feature/item_add/data/models/item_model.dart';

abstract class ItemRemoteDataSource {
  Future<void> addItem(ItemModel item);
  Future<ItemModel?> fetchItemById(String id);
  Future<List<ItemModel>> fetchAllItems();
  Future<void> updateItem(ItemModel item);
  Future<void> deleteItem(String id);
}
