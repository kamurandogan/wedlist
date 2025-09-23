import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';

class GetWishListItems {
  GetWishListItems(this.repository);
  final WishListRepository repository;

  Future<List<ItemEntity>> call(String category, String langCode, String id) {
    return repository.getItems(category, langCode, id);
  }
}
