// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserItemModel {

 String get id; String get title; String get category; double get price; String get note; String get imgUrl;@TimestampConverter() DateTime? get createdAt; List<String> get owners; String get createdBy;
/// Create a copy of UserItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserItemModelCopyWith<UserItemModel> get copyWith => _$UserItemModelCopyWithImpl<UserItemModel>(this as UserItemModel, _$identity);

  /// Serializes this UserItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.note, note) || other.note == note)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.owners, owners)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,price,note,imgUrl,createdAt,const DeepCollectionEquality().hash(owners),createdBy);

@override
String toString() {
  return 'UserItemModel(id: $id, title: $title, category: $category, price: $price, note: $note, imgUrl: $imgUrl, createdAt: $createdAt, owners: $owners, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $UserItemModelCopyWith<$Res>  {
  factory $UserItemModelCopyWith(UserItemModel value, $Res Function(UserItemModel) _then) = _$UserItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String category, double price, String note, String imgUrl,@TimestampConverter() DateTime? createdAt, List<String> owners, String createdBy
});




}
/// @nodoc
class _$UserItemModelCopyWithImpl<$Res>
    implements $UserItemModelCopyWith<$Res> {
  _$UserItemModelCopyWithImpl(this._self, this._then);

  final UserItemModel _self;
  final $Res Function(UserItemModel) _then;

/// Create a copy of UserItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? price = null,Object? note = null,Object? imgUrl = null,Object? createdAt = freezed,Object? owners = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,imgUrl: null == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,owners: null == owners ? _self.owners : owners // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserItemModel].
extension UserItemModelPatterns on UserItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserItemModel value)  $default,){
final _that = this;
switch (_that) {
case _UserItemModel():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double price,  String note,  String imgUrl, @TimestampConverter()  DateTime? createdAt,  List<String> owners,  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserItemModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.price,_that.note,_that.imgUrl,_that.createdAt,_that.owners,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double price,  String note,  String imgUrl, @TimestampConverter()  DateTime? createdAt,  List<String> owners,  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _UserItemModel():
return $default(_that.id,_that.title,_that.category,_that.price,_that.note,_that.imgUrl,_that.createdAt,_that.owners,_that.createdBy);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String category,  double price,  String note,  String imgUrl, @TimestampConverter()  DateTime? createdAt,  List<String> owners,  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _UserItemModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.price,_that.note,_that.imgUrl,_that.createdAt,_that.owners,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserItemModel implements UserItemModel {
  const _UserItemModel({required this.id, required this.title, required this.category, required this.price, required this.note, required this.imgUrl, @TimestampConverter() this.createdAt, final  List<String> owners = const <String>[], this.createdBy = ''}): _owners = owners;
  factory _UserItemModel.fromJson(Map<String, dynamic> json) => _$UserItemModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String category;
@override final  double price;
@override final  String note;
@override final  String imgUrl;
@override@TimestampConverter() final  DateTime? createdAt;
 final  List<String> _owners;
@override@JsonKey() List<String> get owners {
  if (_owners is EqualUnmodifiableListView) return _owners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_owners);
}

@override@JsonKey() final  String createdBy;

/// Create a copy of UserItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserItemModelCopyWith<_UserItemModel> get copyWith => __$UserItemModelCopyWithImpl<_UserItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.price, price) || other.price == price)&&(identical(other.note, note) || other.note == note)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._owners, _owners)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,price,note,imgUrl,createdAt,const DeepCollectionEquality().hash(_owners),createdBy);

@override
String toString() {
  return 'UserItemModel(id: $id, title: $title, category: $category, price: $price, note: $note, imgUrl: $imgUrl, createdAt: $createdAt, owners: $owners, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$UserItemModelCopyWith<$Res> implements $UserItemModelCopyWith<$Res> {
  factory _$UserItemModelCopyWith(_UserItemModel value, $Res Function(_UserItemModel) _then) = __$UserItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String category, double price, String note, String imgUrl,@TimestampConverter() DateTime? createdAt, List<String> owners, String createdBy
});




}
/// @nodoc
class __$UserItemModelCopyWithImpl<$Res>
    implements _$UserItemModelCopyWith<$Res> {
  __$UserItemModelCopyWithImpl(this._self, this._then);

  final _UserItemModel _self;
  final $Res Function(_UserItemModel) _then;

/// Create a copy of UserItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? price = null,Object? note = null,Object? imgUrl = null,Object? createdAt = freezed,Object? owners = null,Object? createdBy = null,}) {
  return _then(_UserItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,imgUrl: null == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,owners: null == owners ? _self._owners : owners // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
