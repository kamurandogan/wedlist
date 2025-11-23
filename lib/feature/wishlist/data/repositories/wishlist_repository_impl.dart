import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';

class WishListRepositoryImpl implements WishListRepository {
  WishListRepositoryImpl(this.remoteDataSource);
  final WishListRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<ItemEntity>>> getItems(
    String category,
    String langCode,
    String id,
  ) async {
    try {
      final items = await remoteDataSource.getItems(category, langCode, id);
      return right(items);
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  /// ⚡ Real-time stream method
  @override
  Stream<Either<Failure, List<ItemEntity>>> getItemsStream(
    String category,
    String langCode,
    String id,
  ) {
    return remoteDataSource
        .getItemsStream(category, langCode, id)
        .map(
          (items) => right<Failure, List<ItemEntity>>(items),
        )
        .handleError((Object error) {
          return left<Failure, List<ItemEntity>>(
            UnexpectedFailure(error.toString()),
          );
        });
  }

  @override
  Future<Either<Failure, void>> addItems(
    String category,
    List<String> titles,
  ) async {
    try {
      await remoteDataSource.addItems(category, titles);
      return right(null);
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
