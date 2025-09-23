import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';

class WishListRepositoryImpl implements WishListRepository {
  WishListRepositoryImpl(this.remoteDataSource);
  final WishListRemoteDataSource remoteDataSource;

  @override
  // ignore: lines_longer_than_80_chars
  Future<List<ItemEntity>> getItems(
    String category,
    String langCode,
    String id,
  ) {
    return remoteDataSource.getItems(category, langCode, id);
  }

  @override
  Future<void> addItems(String category, List<String> titles) {
    return remoteDataSource.addItems(category, titles);
  }
}
