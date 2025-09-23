import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';

class AddWishlistItems {
  AddWishlistItems(this.repository);
  final WishListRepository repository;

  Future<void> call(String category, List<String> titles) {
    return repository.addItems(category, titles);
  }
}
