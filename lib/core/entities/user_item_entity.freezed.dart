// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserItemEntity {

 String get id; String get title; String get category; double get price; String get note; String get imgUrl;// Photo bytes for offline users (when imgUrl is empty)
 Uint8List? get photoBytes; DateTime? get createdAt; List<String> get owners; String get createdBy;// Offline sync metadata
 bool get isPendingSync; bool get isPendingDelete; DateTime? get lastSyncedAt;
/// Create a copy of UserItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserItemEntityCopyWith<UserItemEntity> get copyWith => _$UserItemEntityCopyWithImpl<UserItemEntity>(this as UserItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.note, note) || other.note == note)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&const DeepCollectionEquality().equals(other.photoBytes, photoBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.owners, owners)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.isPendingSync, isPendingSync) || other.isPendingSync == isPendingSync)&&(identical(other.isPendingDelete, isPendingDelete) || other.isPendingDelete == isPendingDelete)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,category,price,note,imgUrl,const DeepCollectionEquality().hash(photoBytes),createdAt,const DeepCollectionEquality().hash(owners),createdBy,isPendingSync,isPendingDelete,lastSyncedAt);

@override
String toString() {
  return 'UserItemEntity(id: $id, title: $title, category: $category, price: $price, note: $note, imgUrl: $imgUrl, photoBytes: $photoBytes, createdAt: $createdAt, owners: $owners, createdBy: $createdBy, isPendingSync: $isPendingSync, isPendingDelete: $isPendingDelete, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class $UserItemEntityCopyWith<$Res>  {
  factory $UserItemEntityCopyWith(UserItemEntity value, $Res Function(UserItemEntity) _then) = _$UserItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String category, double price, String note, String imgUrl, Uint8List? photoBytes, DateTime? createdAt, List<String> owners, String createdBy, bool isPendingSync, bool isPendingDelete, DateTime? lastSyncedAt
});




}
/// @nodoc
class _$UserItemEntityCopyWithImpl<$Res>
    implements $UserItemEntityCopyWith<$Res> {
  _$UserItemEntityCopyWithImpl(this._self, this._then);

  final UserItemEntity _self;
  final $Res Function(UserItemEntity) _then;

/// Create a copy of UserItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? price = null,Object? note = null,Object? imgUrl = null,Object? photoBytes = freezed,Object? createdAt = freezed,Object? owners = null,Object? createdBy = null,Object? isPendingSync = null,Object? isPendingDelete = null,Object? lastSyncedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,imgUrl: null == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String,photoBytes: freezed == photoBytes ? _self.photoBytes : photoBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,owners: null == owners ? _self.owners : owners // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,isPendingSync: null == isPendingSync ? _self.isPendingSync : isPendingSync // ignore: cast_nullable_to_non_nullable
as bool,isPendingDelete: null == isPendingDelete ? _self.isPendingDelete : isPendingDelete // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserItemEntity].
extension UserItemEntityPatterns on UserItemEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserItemEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserItemEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserItemEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double price,  String note,  String imgUrl,  Uint8List? photoBytes,  DateTime? createdAt,  List<String> owners,  String createdBy,  bool isPendingSync,  bool isPendingDelete,  DateTime? lastSyncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserItemEntity() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.price,_that.note,_that.imgUrl,_that.photoBytes,_that.createdAt,_that.owners,_that.createdBy,_that.isPendingSync,_that.isPendingDelete,_that.lastSyncedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double price,  String note,  String imgUrl,  Uint8List? photoBytes,  DateTime? createdAt,  List<String> owners,  String createdBy,  bool isPendingSync,  bool isPendingDelete,  DateTime? lastSyncedAt)  $default,) {final _that = this;
switch (_that) {
case _UserItemEntity():
return $default(_that.id,_that.title,_that.category,_that.price,_that.note,_that.imgUrl,_that.photoBytes,_that.createdAt,_that.owners,_that.createdBy,_that.isPendingSync,_that.isPendingDelete,_that.lastSyncedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String category,  double price,  String note,  String imgUrl,  Uint8List? photoBytes,  DateTime? createdAt,  List<String> owners,  String createdBy,  bool isPendingSync,  bool isPendingDelete,  DateTime? lastSyncedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserItemEntity() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.price,_that.note,_that.imgUrl,_that.photoBytes,_that.createdAt,_that.owners,_that.createdBy,_that.isPendingSync,_that.isPendingDelete,_that.lastSyncedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserItemEntity extends UserItemEntity {
  const _UserItemEntity({required this.id, required this.title, required this.category, required this.price, required this.note, required this.imgUrl, this.photoBytes, this.createdAt, final  List<String> owners = const [], this.createdBy = '', this.isPendingSync = false, this.isPendingDelete = false, this.lastSyncedAt}): _owners = owners,super._();
  

@override final  String id;
@override final  String title;
@override final  String category;
@override final  double price;
@override final  String note;
@override final  String imgUrl;
// Photo bytes for offline users (when imgUrl is empty)
@override final  Uint8List? photoBytes;
@override final  DateTime? createdAt;
 final  List<String> _owners;
@override@JsonKey() List<String> get owners {
  if (_owners is EqualUnmodifiableListView) return _owners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_owners);
}

@override@JsonKey() final  String createdBy;
// Offline sync metadata
@override@JsonKey() final  bool isPendingSync;
@override@JsonKey() final  bool isPendingDelete;
@override final  DateTime? lastSyncedAt;

/// Create a copy of UserItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserItemEntityCopyWith<_UserItemEntity> get copyWith => __$UserItemEntityCopyWithImpl<_UserItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.note, note) || other.note == note)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&const DeepCollectionEquality().equals(other.photoBytes, photoBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._owners, _owners)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.isPendingSync, isPendingSync) || other.isPendingSync == isPendingSync)&&(identical(other.isPendingDelete, isPendingDelete) || other.isPendingDelete == isPendingDelete)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,category,price,note,imgUrl,const DeepCollectionEquality().hash(photoBytes),createdAt,const DeepCollectionEquality().hash(_owners),createdBy,isPendingSync,isPendingDelete,lastSyncedAt);

@override
String toString() {
  return 'UserItemEntity(id: $id, title: $title, category: $category, price: $price, note: $note, imgUrl: $imgUrl, photoBytes: $photoBytes, createdAt: $createdAt, owners: $owners, createdBy: $createdBy, isPendingSync: $isPendingSync, isPendingDelete: $isPendingDelete, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class _$UserItemEntityCopyWith<$Res> implements $UserItemEntityCopyWith<$Res> {
  factory _$UserItemEntityCopyWith(_UserItemEntity value, $Res Function(_UserItemEntity) _then) = __$UserItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String category, double price, String note, String imgUrl, Uint8List? photoBytes, DateTime? createdAt, List<String> owners, String createdBy, bool isPendingSync, bool isPendingDelete, DateTime? lastSyncedAt
});




}
/// @nodoc
class __$UserItemEntityCopyWithImpl<$Res>
    implements _$UserItemEntityCopyWith<$Res> {
  __$UserItemEntityCopyWithImpl(this._self, this._then);

  final _UserItemEntity _self;
  final $Res Function(_UserItemEntity) _then;

/// Create a copy of UserItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? price = null,Object? note = null,Object? imgUrl = null,Object? photoBytes = freezed,Object? createdAt = freezed,Object? owners = null,Object? createdBy = null,Object? isPendingSync = null,Object? isPendingDelete = null,Object? lastSyncedAt = freezed,}) {
  return _then(_UserItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,imgUrl: null == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String,photoBytes: freezed == photoBytes ? _self.photoBytes : photoBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,owners: null == owners ? _self._owners : owners // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,isPendingSync: null == isPendingSync ? _self.isPendingSync : isPendingSync // ignore: cast_nullable_to_non_nullable
as bool,isPendingDelete: null == isPendingDelete ? _self.isPendingDelete : isPendingDelete // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
