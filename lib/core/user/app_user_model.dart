import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/item/item_model.dart' as core;
import 'package:wedlist/core/user/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  AppUserModel({
    required super.uid,
    required super.email,
    required super.name,
    super.wishList = const <ItemEntity>[],
    super.receivedList = const <ItemEntity>[],
    super.collaborators = const <String>[],
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json, String uid) {
    return AppUserModel(
      uid: uid,
      email: (json['email'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      wishList: ((json['wishList'] as List?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map((e) => core.ItemModel.fromJson(e).toEntity())
          .toList(),
      receivedList: ((json['receivedList'] as List?) ?? const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map((e) => core.ItemModel.fromJson(e).toEntity())
          .toList(),
      collaborators: (json['collaborators'] as List?)?.cast<String>() ?? const <String>[],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'wishList': wishList.map((e) => core.ItemModel.fromEntity(e).toJson()).toList(),
    'receivedList': receivedList.map((e) => core.ItemModel.fromEntity(e).toJson()).toList(),
    'collaborators': collaborators,
  };

  AppUserModel copyWith({
    String? email,
    String? name,
    List<ItemEntity>? wishList,
    List<ItemEntity>? receivedList,
    List<String>? collaborators,
  }) {
    return AppUserModel(
      uid: uid,
      email: email ?? this.email,
      name: name ?? this.name,
      wishList: wishList ?? this.wishList,
      receivedList: receivedList ?? this.receivedList,
      collaborators: collaborators ?? this.collaborators,
    );
  }
}
