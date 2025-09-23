import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/categort_repository.dart';

class GetCategoryItems {
  GetCategoryItems(this.categoryRepository);
  final CategoryRepository categoryRepository;

  Future<List<CategoryItem>> call(String title, String langCode) async {
    return categoryRepository.getCategories(title, langCode);
  }

  // Future<List<String>> getFirebaseKeys() async {
  //   return await categoryRepository.getFirebaseKeys();
  // }
}
