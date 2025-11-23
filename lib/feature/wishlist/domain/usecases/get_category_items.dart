import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/category_repository.dart';

class GetCategoryItems {
  GetCategoryItems(this.categoryRepository);
  final CategoryRepository categoryRepository;

  Future<Either<Failure, List<CategoryItem>>> call(
    String title,
    String langCode,
  ) async {
    return categoryRepository.getCategories(title, langCode);
  }

  // Future<List<String>> getFirebaseKeys() async {
  //   return await categoryRepository.getFirebaseKeys();
  // }
}
