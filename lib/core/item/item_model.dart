import 'package:wedlist/core/item/item_entity.dart';

class ItemModel {
  ItemModel({
    required this.id,
    required this.title,
    required this.category,
    this.isPendingSync = false,
    this.isPendingDelete = false,
    this.lastSyncedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    isPendingSync: json['isPendingSync'] as bool? ?? false,
    isPendingDelete: json['isPendingDelete'] as bool? ?? false,
    lastSyncedAt: json['lastSyncedAt'] != null
        ? DateTime.parse(json['lastSyncedAt'] as String)
        : null,
  );

  factory ItemModel.fromEntity(ItemEntity e) => ItemModel(
    id: e.id,
    title: e.title,
    category: e.category,
    isPendingSync: e.isPendingSync,
    isPendingDelete: e.isPendingDelete,
    lastSyncedAt: e.lastSyncedAt,
  );

  final String id;
  final String title;
  final String category;
  final bool isPendingSync;
  final bool isPendingDelete;
  final DateTime? lastSyncedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'isPendingSync': isPendingSync,
    'isPendingDelete': isPendingDelete,
    'lastSyncedAt': lastSyncedAt?.toIso8601String(),
  };

  ItemEntity toEntity() => ItemEntity(
    id: id,
    title: title,
    category: category,
    isPendingSync: isPendingSync,
    isPendingDelete: isPendingDelete,
    lastSyncedAt: lastSyncedAt,
  );
}
