import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';

class CategoryItemModel extends CategoryItem {
  CategoryItemModel({
    required String title,
  }) : super(title);

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      title: json['title'] as String,
    );
  }
}
