import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/wishlist/data/datasources/category_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this.remoteDataSource);
  final CategoryRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<CategoryItem>>> getCategories(
    String title,
    String langCode,
  ) async {
    try {
      final categories = await remoteDataSource.getCategories(title, langCode);
      return right(categories);
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  // @override
  // Future<List<String>> getFirebaseKeys() {
  //   return remoteDataSource.getFirebaseKeys();
  // }
}
