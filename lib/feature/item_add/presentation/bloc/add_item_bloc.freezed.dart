// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_item_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddItemEvent {

 String get title; String get category; String? get id; String? get price; String? get note; String? get imgUrl;
/// Create a copy of AddItemEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddItemEventCopyWith<AddItemEvent> get copyWith => _$AddItemEventCopyWithImpl<AddItemEvent>(this as AddItemEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.id, id) || other.id == id)&&(identical(other.price, price) || other.price == price)&&(identical(other.note, note) || other.note == note)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl));
}


@override
int get hashCode => Object.hash(runtimeType,title,category,id,price,note,imgUrl);

@override
String toString() {
  return 'AddItemEvent(title: $title, category: $category, id: $id, price: $price, note: $note, imgUrl: $imgUrl)';
}


}

/// @nodoc
abstract mixin class $AddItemEventCopyWith<$Res>  {
  factory $AddItemEventCopyWith(AddItemEvent value, $Res Function(AddItemEvent) _then) = _$AddItemEventCopyWithImpl;
@useResult
$Res call({
 String title, String category, String? id, String? price, String? note, String? imgUrl
});




}
/// @nodoc
class _$AddItemEventCopyWithImpl<$Res>
    implements $AddItemEventCopyWith<$Res> {
  _$AddItemEventCopyWithImpl(this._self, this._then);

  final AddItemEvent _self;
  final $Res Function(AddItemEvent) _then;

/// Create a copy of AddItemEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? category = null,Object? id = freezed,Object? price = freezed,Object? note = freezed,Object? imgUrl = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,imgUrl: freezed == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AddItemEvent].
extension AddItemEventPatterns on AddItemEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddItemButtonPressed value)?  addItemButtonPressed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddItemButtonPressed() when addItemButtonPressed != null:
return addItemButtonPressed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddItemButtonPressed value)  addItemButtonPressed,}){
final _that = this;
switch (_that) {
case AddItemButtonPressed():
return addItemButtonPressed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddItemButtonPressed value)?  addItemButtonPressed,}){
final _that = this;
switch (_that) {
case AddItemButtonPressed() when addItemButtonPressed != null:
return addItemButtonPressed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  String category,  String? id,  String? price,  String? note,  String? imgUrl)?  addItemButtonPressed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddItemButtonPressed() when addItemButtonPressed != null:
return addItemButtonPressed(_that.title,_that.category,_that.id,_that.price,_that.note,_that.imgUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  String category,  String? id,  String? price,  String? note,  String? imgUrl)  addItemButtonPressed,}) {final _that = this;
switch (_that) {
case AddItemButtonPressed():
return addItemButtonPressed(_that.title,_that.category,_that.id,_that.price,_that.note,_that.imgUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  String category,  String? id,  String? price,  String? note,  String? imgUrl)?  addItemButtonPressed,}) {final _that = this;
switch (_that) {
case AddItemButtonPressed() when addItemButtonPressed != null:
return addItemButtonPressed(_that.title,_that.category,_that.id,_that.price,_that.note,_that.imgUrl);case _:
  return null;

}
}

}

/// @nodoc


class AddItemButtonPressed implements AddItemEvent {
  const AddItemButtonPressed({required this.title, required this.category, this.id, this.price, this.note, this.imgUrl});
  

@override final  String title;
@override final  String category;
@override final  String? id;
@override final  String? price;
@override final  String? note;
@override final  String? imgUrl;

/// Create a copy of AddItemEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddItemButtonPressedCopyWith<AddItemButtonPressed> get copyWith => _$AddItemButtonPressedCopyWithImpl<AddItemButtonPressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemButtonPressed&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.id, id) || other.id == id)&&(identical(other.price, price) || other.price == price)&&(identical(other.note, note) || other.note == note)&&(identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl));
}


@override
int get hashCode => Object.hash(runtimeType,title,category,id,price,note,imgUrl);

@override
String toString() {
  return 'AddItemEvent.addItemButtonPressed(title: $title, category: $category, id: $id, price: $price, note: $note, imgUrl: $imgUrl)';
}


}

/// @nodoc
abstract mixin class $AddItemButtonPressedCopyWith<$Res> implements $AddItemEventCopyWith<$Res> {
  factory $AddItemButtonPressedCopyWith(AddItemButtonPressed value, $Res Function(AddItemButtonPressed) _then) = _$AddItemButtonPressedCopyWithImpl;
@override @useResult
$Res call({
 String title, String category, String? id, String? price, String? note, String? imgUrl
});




}
/// @nodoc
class _$AddItemButtonPressedCopyWithImpl<$Res>
    implements $AddItemButtonPressedCopyWith<$Res> {
  _$AddItemButtonPressedCopyWithImpl(this._self, this._then);

  final AddItemButtonPressed _self;
  final $Res Function(AddItemButtonPressed) _then;

/// Create a copy of AddItemEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? category = null,Object? id = freezed,Object? price = freezed,Object? note = freezed,Object? imgUrl = freezed,}) {
  return _then(AddItemButtonPressed(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,imgUrl: freezed == imgUrl ? _self.imgUrl : imgUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$AddItemState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddItemState()';
}


}

/// @nodoc
class $AddItemStateCopyWith<$Res>  {
$AddItemStateCopyWith(AddItemState _, $Res Function(AddItemState) __);
}


/// Adds pattern-matching-related methods to [AddItemState].
extension AddItemStatePatterns on AddItemState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddItemInitial value)?  initial,TResult Function( AddItemLoading value)?  loading,TResult Function( AddItemSuccess value)?  success,TResult Function( AddItemFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddItemInitial() when initial != null:
return initial(_that);case AddItemLoading() when loading != null:
return loading(_that);case AddItemSuccess() when success != null:
return success(_that);case AddItemFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddItemInitial value)  initial,required TResult Function( AddItemLoading value)  loading,required TResult Function( AddItemSuccess value)  success,required TResult Function( AddItemFailure value)  failure,}){
final _that = this;
switch (_that) {
case AddItemInitial():
return initial(_that);case AddItemLoading():
return loading(_that);case AddItemSuccess():
return success(_that);case AddItemFailure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddItemInitial value)?  initial,TResult? Function( AddItemLoading value)?  loading,TResult? Function( AddItemSuccess value)?  success,TResult? Function( AddItemFailure value)?  failure,}){
final _that = this;
switch (_that) {
case AddItemInitial() when initial != null:
return initial(_that);case AddItemLoading() when loading != null:
return loading(_that);case AddItemSuccess() when success != null:
return success(_that);case AddItemFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddItemInitial() when initial != null:
return initial();case AddItemLoading() when loading != null:
return loading();case AddItemSuccess() when success != null:
return success();case AddItemFailure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case AddItemInitial():
return initial();case AddItemLoading():
return loading();case AddItemSuccess():
return success();case AddItemFailure():
return failure(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case AddItemInitial() when initial != null:
return initial();case AddItemLoading() when loading != null:
return loading();case AddItemSuccess() when success != null:
return success();case AddItemFailure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AddItemInitial implements AddItemState {
  const AddItemInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddItemState.initial()';
}


}




/// @nodoc


class AddItemLoading implements AddItemState {
  const AddItemLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddItemState.loading()';
}


}




/// @nodoc


class AddItemSuccess implements AddItemState {
  const AddItemSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddItemState.success()';
}


}




/// @nodoc


class AddItemFailure implements AddItemState {
  const AddItemFailure(this.message);
  

 final  String message;

/// Create a copy of AddItemState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddItemFailureCopyWith<AddItemFailure> get copyWith => _$AddItemFailureCopyWithImpl<AddItemFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddItemFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AddItemState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class $AddItemFailureCopyWith<$Res> implements $AddItemStateCopyWith<$Res> {
  factory $AddItemFailureCopyWith(AddItemFailure value, $Res Function(AddItemFailure) _then) = _$AddItemFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AddItemFailureCopyWithImpl<$Res>
    implements $AddItemFailureCopyWith<$Res> {
  _$AddItemFailureCopyWithImpl(this._self, this._then);

  final AddItemFailure _self;
  final $Res Function(AddItemFailure) _then;

/// Create a copy of AddItemState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AddItemFailure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
