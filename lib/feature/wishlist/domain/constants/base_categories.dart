import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';

/// Base wishlist categories used as fallback when offline with no cached data
class BaseCategories {
  static const List<String> categoryNames = [
    'Electronics',
    'Kitchen',
    'Bedroom',
    'Bathroom',
    'Living Room',
    'Furniture',
    'Appliances',
    'Other',
  ];

  /// Convert category names to CategoryItem entities
  static List<CategoryItem> getBaseCategories() {
    return categoryNames.map(CategoryItem.new).toList();
  }
}
