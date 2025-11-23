import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryItem>>> getCategories(
    String title,
    String langCode,
  );
  // Future<List<String>> getFirebaseKeys();
}
