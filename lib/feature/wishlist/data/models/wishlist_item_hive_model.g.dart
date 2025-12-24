// Manual TypeAdapter for WishlistItemHiveModel
part of 'wishlist_item_hive_model.dart';

// coverage:ignore-file
// ignore_for_file: type=lint

class WishlistItemHiveModelAdapter extends TypeAdapter<WishlistItemHiveModel> {
  @override
  final int typeId = 1;

  @override
  WishlistItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItemHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      isPendingSync: fields[3] as bool? ?? false,
      isPendingDelete: fields[4] as bool? ?? false,
      lastSyncedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItemHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.isPendingSync)
      ..writeByte(4)
      ..write(obj.isPendingDelete)
      ..writeByte(5)
      ..write(obj.lastSyncedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
