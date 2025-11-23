import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';

class GetWishListItems {
  GetWishListItems(this.repository);
  final WishListRepository repository;

  /// One-time fetch (existing - backward compatible)
  Future<Either<Failure, List<ItemEntity>>> call(
    String category,
    String langCode,
    String id,
  ) {
    return repository.getItems(category, langCode, id);
  }

  /// ⚡ Real-time stream (NEW - for reactive updates)
  Stream<Either<Failure, List<ItemEntity>>> stream(
    String category,
    String langCode,
    String id,
  ) {
    return repository.getItemsStream(category, langCode, id);
  }
}
