// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserItemModel _$UserItemModelFromJson(Map<String, dynamic> json) =>
    _UserItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      note: json['note'] as String,
      imgUrl: json['imgUrl'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      owners:
          (json['owners'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      createdBy: json['createdBy'] as String? ?? '',
    );

Map<String, dynamic> _$UserItemModelToJson(_UserItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'price': instance.price,
      'note': instance.note,
      'imgUrl': instance.imgUrl,
      'createdAt': _$JsonConverterToJson<Object?, DateTime>(
        instance.createdAt,
        const TimestampConverter().toJson,
      ),
      'owners': instance.owners,
      'createdBy': instance.createdBy,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
