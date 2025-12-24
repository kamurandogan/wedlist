import 'package:hive/hive.dart';
import 'package:wedlist/core/item/item_entity.dart';

part 'wishlist_item_hive_model.g.dart';

@HiveType(typeId: 1)
class WishlistItemHiveModel extends HiveObject {
  WishlistItemHiveModel({
    required this.id,
    required this.title,
    required this.category,
    this.isPendingSync = false,
    this.isPendingDelete = false,
    this.lastSyncedAt,
  });

  factory WishlistItemHiveModel.fromEntity(ItemEntity entity) {
    return WishlistItemHiveModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      isPendingSync: entity.isPendingSync,
      isPendingDelete: entity.isPendingDelete,
      lastSyncedAt: entity.lastSyncedAt,
    );
  }

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  bool isPendingSync;

  @HiveField(4)
  bool isPendingDelete;

  @HiveField(5)
  DateTime? lastSyncedAt;

  ItemEntity toEntity() {
    return ItemEntity(
      id: id,
      title: title,
      category: category,
      isPendingSync: isPendingSync,
      isPendingDelete: isPendingDelete,
      lastSyncedAt: lastSyncedAt,
    );
  }
}
