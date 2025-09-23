import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedlist/core/json/timestamp_converter.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';

part 'user_item_model.freezed.dart';
part 'user_item_model.g.dart';

@freezed
sealed class UserItemModel with _$UserItemModel {
  const factory UserItemModel({
    required String id,
    required String title,
    required String category,
    required double price,
    required String note,
    required String imgUrl,
    @TimestampConverter() DateTime? createdAt,
    @Default(<String>[]) List<String> owners,
    @Default('') String createdBy,
  }) = _UserItemModel;

  factory UserItemModel.fromJson(Map<String, dynamic> json) => _$UserItemModelFromJson(json);

  factory UserItemModel.fromEntity(UserItemEntity entity) => UserItemModel(
    id: entity.id,
    title: entity.title,
    category: entity.category,
    price: entity.price,
    note: entity.note,
    imgUrl: entity.imgUrl,
    createdAt: entity.createdAt,
    owners: entity.owners,
    createdBy: entity.createdBy,
  );
}

extension UserItemModelX on UserItemModel {
  UserItemEntity toEntity() => UserItemEntity(
    price,
    note,
    imgUrl,
    id: id,
    title: title,
    category: category,
    createdAt: createdAt,
    owners: owners,
    createdBy: createdBy,
  );
}
