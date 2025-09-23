import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';

abstract class CategoryRepository {
  Future<List<CategoryItem>> getCategories(String title, String langCode);
  // Future<List<String>> getFirebaseKeys();
}
