// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_item_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserItemHiveModelAdapter extends TypeAdapter<UserItemHiveModel> {
  @override
  final int typeId = 0;

  @override
  UserItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserItemHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      price: fields[3] as double,
      note: fields[4] as String,
      imgUrl: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      owners: (fields[7] as List?)?.cast<String>() ?? const [],
      createdBy: fields[8] as String? ?? '',
      isPendingSync: fields[9] as bool? ?? false,
      isPendingDelete: fields[10] as bool? ?? false,
      lastSyncedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserItemHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.imgUrl)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.owners)
      ..writeByte(8)
      ..write(obj.createdBy)
      ..writeByte(9)
      ..write(obj.isPendingSync)
      ..writeByte(10)
      ..write(obj.isPendingDelete)
      ..writeByte(11)
      ..write(obj.lastSyncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
