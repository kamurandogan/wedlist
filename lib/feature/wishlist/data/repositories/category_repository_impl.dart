import 'package:wedlist/feature/wishlist/data/datasources/category_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/categort_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this.remoteDataSource);
  final CategoryRemoteDataSource remoteDataSource;

  @override
  Future<List<CategoryItem>> getCategories(String title, String langCode) {
    return remoteDataSource.getCategories(title, langCode);
  }

  // @override
  // Future<List<String>> getFirebaseKeys() {
  //   return remoteDataSource.getFirebaseKeys();
  // }
}
