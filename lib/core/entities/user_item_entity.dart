import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_item_entity.freezed.dart';

@freezed
abstract class UserItemEntity with _$UserItemEntity {
  const factory UserItemEntity({
    required String id,
    required String title,
    required String category,
    required double price,
    required String note,
    required String imgUrl,
    DateTime? createdAt,
    @Default([]) List<String> owners,
    @Default('') String createdBy,
    // Offline sync metadata
    @Default(false) bool isPendingSync,
    @Default(false) bool isPendingDelete,
    DateTime? lastSyncedAt,
  }) = _UserItemEntity;

  const UserItemEntity._();
}
