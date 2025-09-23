import 'package:wedlist/core/item/item_entity.dart';

class ItemModel {
  ItemModel({required this.id, required this.title, required this.category});

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
  );

  factory ItemModel.fromEntity(ItemEntity e) =>
      ItemModel(id: e.id, title: e.title, category: e.category);

  final String id;
  final String title;
  final String category;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
  };

  ItemEntity toEntity() => ItemEntity(id: id, title: title, category: category);
}
