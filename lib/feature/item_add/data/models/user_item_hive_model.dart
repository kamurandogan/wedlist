import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';

part 'user_item_hive_model.g.dart'; // Manuel TypeAdapter'ımız

@HiveType(typeId: 0)
class UserItemHiveModel extends HiveObject {
  UserItemHiveModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.note,
    required this.imgUrl,
    this.photoBytes,
    this.createdAt,
    this.owners = const [],
    this.createdBy = '',
    this.isPendingSync = false,
    this.isPendingDelete = false,
    this.lastSyncedAt,
  });

  factory UserItemHiveModel.fromEntity(UserItemEntity entity) {
    return UserItemHiveModel(
      id: entity.id,
      title: entity.title,
      category: entity.category,
      price: entity.price,
      note: entity.note,
      imgUrl: entity.imgUrl,
      photoBytes: entity.photoBytes,
      createdAt: entity.createdAt,
      owners: entity.owners,
      createdBy: entity.createdBy,
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
  double price;

  @HiveField(4)
  String note;

  @HiveField(5)
  String imgUrl;

  @HiveField(6)
  DateTime? createdAt;

  @HiveField(7)
  List<String> owners;

  @HiveField(8)
  String createdBy;

  @HiveField(9)
  bool isPendingSync;

  @HiveField(10)
  bool isPendingDelete;

  @HiveField(11)
  DateTime? lastSyncedAt;

  @HiveField(12)
  Uint8List? photoBytes;

  UserItemEntity toEntity() {
    return UserItemEntity(
      id: id,
      title: title,
      category: category,
      price: price,
      note: note,
      imgUrl: imgUrl,
      photoBytes: photoBytes,
      createdAt: createdAt,
      owners: owners,
      createdBy: createdBy,
      isPendingSync: isPendingSync,
      isPendingDelete: isPendingDelete,
      lastSyncedAt: lastSyncedAt,
    );
  }
}
