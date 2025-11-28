// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dowry_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DowryListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListEvent()';
}


}

/// @nodoc
class $DowryListEventCopyWith<$Res>  {
$DowryListEventCopyWith(DowryListEvent _, $Res Function(DowryListEvent) __);
}


/// Adds pattern-matching-related methods to [DowryListEvent].
extension DowryListEventPatterns on DowryListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FetchDowryListItems value)?  fetchDowryListItems,TResult Function( DeleteDowryItem value)?  deleteDowryItem,TResult Function( UpdateDowryItem value)?  updateDowryItem,TResult Function( SubscribeDowryItems value)?  subscribeDowryItems,TResult Function( _OptimisticInsert value)?  optimisticInsert,TResult Function( _DowryItemsStreamUpdated value)?  dowryItemsStreamUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FetchDowryListItems() when fetchDowryListItems != null:
return fetchDowryListItems(_that);case DeleteDowryItem() when deleteDowryItem != null:
return deleteDowryItem(_that);case UpdateDowryItem() when updateDowryItem != null:
return updateDowryItem(_that);case SubscribeDowryItems() when subscribeDowryItems != null:
return subscribeDowryItems(_that);case _OptimisticInsert() when optimisticInsert != null:
return optimisticInsert(_that);case _DowryItemsStreamUpdated() when dowryItemsStreamUpdated != null:
return dowryItemsStreamUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FetchDowryListItems value)  fetchDowryListItems,required TResult Function( DeleteDowryItem value)  deleteDowryItem,required TResult Function( UpdateDowryItem value)  updateDowryItem,required TResult Function( SubscribeDowryItems value)  subscribeDowryItems,required TResult Function( _OptimisticInsert value)  optimisticInsert,required TResult Function( _DowryItemsStreamUpdated value)  dowryItemsStreamUpdated,}){
final _that = this;
switch (_that) {
case FetchDowryListItems():
return fetchDowryListItems(_that);case DeleteDowryItem():
return deleteDowryItem(_that);case UpdateDowryItem():
return updateDowryItem(_that);case SubscribeDowryItems():
return subscribeDowryItems(_that);case _OptimisticInsert():
return optimisticInsert(_that);case _DowryItemsStreamUpdated():
return dowryItemsStreamUpdated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FetchDowryListItems value)?  fetchDowryListItems,TResult? Function( DeleteDowryItem value)?  deleteDowryItem,TResult? Function( UpdateDowryItem value)?  updateDowryItem,TResult? Function( SubscribeDowryItems value)?  subscribeDowryItems,TResult? Function( _OptimisticInsert value)?  optimisticInsert,TResult? Function( _DowryItemsStreamUpdated value)?  dowryItemsStreamUpdated,}){
final _that = this;
switch (_that) {
case FetchDowryListItems() when fetchDowryListItems != null:
return fetchDowryListItems(_that);case DeleteDowryItem() when deleteDowryItem != null:
return deleteDowryItem(_that);case UpdateDowryItem() when updateDowryItem != null:
return updateDowryItem(_that);case SubscribeDowryItems() when subscribeDowryItems != null:
return subscribeDowryItems(_that);case _OptimisticInsert() when optimisticInsert != null:
return optimisticInsert(_that);case _DowryItemsStreamUpdated() when dowryItemsStreamUpdated != null:
return dowryItemsStreamUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetchDowryListItems,TResult Function( String id)?  deleteDowryItem,TResult Function( UserItemEntity updatedItem)?  updateDowryItem,TResult Function()?  subscribeDowryItems,TResult Function( UserItemEntity item)?  optimisticInsert,TResult Function( List<UserItemEntity> items)?  dowryItemsStreamUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FetchDowryListItems() when fetchDowryListItems != null:
return fetchDowryListItems();case DeleteDowryItem() when deleteDowryItem != null:
return deleteDowryItem(_that.id);case UpdateDowryItem() when updateDowryItem != null:
return updateDowryItem(_that.updatedItem);case SubscribeDowryItems() when subscribeDowryItems != null:
return subscribeDowryItems();case _OptimisticInsert() when optimisticInsert != null:
return optimisticInsert(_that.item);case _DowryItemsStreamUpdated() when dowryItemsStreamUpdated != null:
return dowryItemsStreamUpdated(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetchDowryListItems,required TResult Function( String id)  deleteDowryItem,required TResult Function( UserItemEntity updatedItem)  updateDowryItem,required TResult Function()  subscribeDowryItems,required TResult Function( UserItemEntity item)  optimisticInsert,required TResult Function( List<UserItemEntity> items)  dowryItemsStreamUpdated,}) {final _that = this;
switch (_that) {
case FetchDowryListItems():
return fetchDowryListItems();case DeleteDowryItem():
return deleteDowryItem(_that.id);case UpdateDowryItem():
return updateDowryItem(_that.updatedItem);case SubscribeDowryItems():
return subscribeDowryItems();case _OptimisticInsert():
return optimisticInsert(_that.item);case _DowryItemsStreamUpdated():
return dowryItemsStreamUpdated(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetchDowryListItems,TResult? Function( String id)?  deleteDowryItem,TResult? Function( UserItemEntity updatedItem)?  updateDowryItem,TResult? Function()?  subscribeDowryItems,TResult? Function( UserItemEntity item)?  optimisticInsert,TResult? Function( List<UserItemEntity> items)?  dowryItemsStreamUpdated,}) {final _that = this;
switch (_that) {
case FetchDowryListItems() when fetchDowryListItems != null:
return fetchDowryListItems();case DeleteDowryItem() when deleteDowryItem != null:
return deleteDowryItem(_that.id);case UpdateDowryItem() when updateDowryItem != null:
return updateDowryItem(_that.updatedItem);case SubscribeDowryItems() when subscribeDowryItems != null:
return subscribeDowryItems();case _OptimisticInsert() when optimisticInsert != null:
return optimisticInsert(_that.item);case _DowryItemsStreamUpdated() when dowryItemsStreamUpdated != null:
return dowryItemsStreamUpdated(_that.items);case _:
  return null;

}
}

}

/// @nodoc


class FetchDowryListItems implements DowryListEvent {
  const FetchDowryListItems();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchDowryListItems);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListEvent.fetchDowryListItems()';
}


}




/// @nodoc


class DeleteDowryItem implements DowryListEvent {
  const DeleteDowryItem(this.id);
  

 final  String id;

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteDowryItemCopyWith<DeleteDowryItem> get copyWith => _$DeleteDowryItemCopyWithImpl<DeleteDowryItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteDowryItem&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DowryListEvent.deleteDowryItem(id: $id)';
}


}

/// @nodoc
abstract mixin class $DeleteDowryItemCopyWith<$Res> implements $DowryListEventCopyWith<$Res> {
  factory $DeleteDowryItemCopyWith(DeleteDowryItem value, $Res Function(DeleteDowryItem) _then) = _$DeleteDowryItemCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DeleteDowryItemCopyWithImpl<$Res>
    implements $DeleteDowryItemCopyWith<$Res> {
  _$DeleteDowryItemCopyWithImpl(this._self, this._then);

  final DeleteDowryItem _self;
  final $Res Function(DeleteDowryItem) _then;

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DeleteDowryItem(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateDowryItem implements DowryListEvent {
  const UpdateDowryItem(this.updatedItem);
  

 final  UserItemEntity updatedItem;

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateDowryItemCopyWith<UpdateDowryItem> get copyWith => _$UpdateDowryItemCopyWithImpl<UpdateDowryItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateDowryItem&&(identical(other.updatedItem, updatedItem) || other.updatedItem == updatedItem));
}


@override
int get hashCode => Object.hash(runtimeType,updatedItem);

@override
String toString() {
  return 'DowryListEvent.updateDowryItem(updatedItem: $updatedItem)';
}


}

/// @nodoc
abstract mixin class $UpdateDowryItemCopyWith<$Res> implements $DowryListEventCopyWith<$Res> {
  factory $UpdateDowryItemCopyWith(UpdateDowryItem value, $Res Function(UpdateDowryItem) _then) = _$UpdateDowryItemCopyWithImpl;
@useResult
$Res call({
 UserItemEntity updatedItem
});


$UserItemEntityCopyWith<$Res> get updatedItem;

}
/// @nodoc
class _$UpdateDowryItemCopyWithImpl<$Res>
    implements $UpdateDowryItemCopyWith<$Res> {
  _$UpdateDowryItemCopyWithImpl(this._self, this._then);

  final UpdateDowryItem _self;
  final $Res Function(UpdateDowryItem) _then;

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? updatedItem = null,}) {
  return _then(UpdateDowryItem(
null == updatedItem ? _self.updatedItem : updatedItem // ignore: cast_nullable_to_non_nullable
as UserItemEntity,
  ));
}

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserItemEntityCopyWith<$Res> get updatedItem {
  
  return $UserItemEntityCopyWith<$Res>(_self.updatedItem, (value) {
    return _then(_self.copyWith(updatedItem: value));
  });
}
}

/// @nodoc


class SubscribeDowryItems implements DowryListEvent {
  const SubscribeDowryItems();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscribeDowryItems);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListEvent.subscribeDowryItems()';
}


}




/// @nodoc


class _OptimisticInsert implements DowryListEvent {
  const _OptimisticInsert(this.item);
  

 final  UserItemEntity item;

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptimisticInsertCopyWith<_OptimisticInsert> get copyWith => __$OptimisticInsertCopyWithImpl<_OptimisticInsert>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptimisticInsert&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'DowryListEvent.optimisticInsert(item: $item)';
}


}

/// @nodoc
abstract mixin class _$OptimisticInsertCopyWith<$Res> implements $DowryListEventCopyWith<$Res> {
  factory _$OptimisticInsertCopyWith(_OptimisticInsert value, $Res Function(_OptimisticInsert) _then) = __$OptimisticInsertCopyWithImpl;
@useResult
$Res call({
 UserItemEntity item
});


$UserItemEntityCopyWith<$Res> get item;

}
/// @nodoc
class __$OptimisticInsertCopyWithImpl<$Res>
    implements _$OptimisticInsertCopyWith<$Res> {
  __$OptimisticInsertCopyWithImpl(this._self, this._then);

  final _OptimisticInsert _self;
  final $Res Function(_OptimisticInsert) _then;

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(_OptimisticInsert(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as UserItemEntity,
  ));
}

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserItemEntityCopyWith<$Res> get item {
  
  return $UserItemEntityCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class _DowryItemsStreamUpdated implements DowryListEvent {
  const _DowryItemsStreamUpdated(final  List<UserItemEntity> items): _items = items;
  

 final  List<UserItemEntity> _items;
 List<UserItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DowryItemsStreamUpdatedCopyWith<_DowryItemsStreamUpdated> get copyWith => __$DowryItemsStreamUpdatedCopyWithImpl<_DowryItemsStreamUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DowryItemsStreamUpdated&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'DowryListEvent.dowryItemsStreamUpdated(items: $items)';
}


}

/// @nodoc
abstract mixin class _$DowryItemsStreamUpdatedCopyWith<$Res> implements $DowryListEventCopyWith<$Res> {
  factory _$DowryItemsStreamUpdatedCopyWith(_DowryItemsStreamUpdated value, $Res Function(_DowryItemsStreamUpdated) _then) = __$DowryItemsStreamUpdatedCopyWithImpl;
@useResult
$Res call({
 List<UserItemEntity> items
});




}
/// @nodoc
class __$DowryItemsStreamUpdatedCopyWithImpl<$Res>
    implements _$DowryItemsStreamUpdatedCopyWith<$Res> {
  __$DowryItemsStreamUpdatedCopyWithImpl(this._self, this._then);

  final _DowryItemsStreamUpdated _self;
  final $Res Function(_DowryItemsStreamUpdated) _then;

/// Create a copy of DowryListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_DowryItemsStreamUpdated(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<UserItemEntity>,
  ));
}


}

/// @nodoc
mixin _$DowryListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListState()';
}


}

/// @nodoc
class $DowryListStateCopyWith<$Res>  {
$DowryListStateCopyWith(DowryListState _, $Res Function(DowryListState) __);
}


/// Adds pattern-matching-related methods to [DowryListState].
extension DowryListStatePatterns on DowryListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DowryListInitial value)?  initial,TResult Function( DowryListLoading value)?  loading,TResult Function( DowryListLoaded value)?  loaded,TResult Function( DowryListError value)?  error,TResult Function( DowryListEmpty value)?  empty,TResult Function( DowryItemAdded value)?  itemAdded,TResult Function( DowryItemDeleted value)?  itemDeleted,TResult Function( DowryItemUpdated value)?  itemUpdated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DowryListInitial() when initial != null:
return initial(_that);case DowryListLoading() when loading != null:
return loading(_that);case DowryListLoaded() when loaded != null:
return loaded(_that);case DowryListError() when error != null:
return error(_that);case DowryListEmpty() when empty != null:
return empty(_that);case DowryItemAdded() when itemAdded != null:
return itemAdded(_that);case DowryItemDeleted() when itemDeleted != null:
return itemDeleted(_that);case DowryItemUpdated() when itemUpdated != null:
return itemUpdated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DowryListInitial value)  initial,required TResult Function( DowryListLoading value)  loading,required TResult Function( DowryListLoaded value)  loaded,required TResult Function( DowryListError value)  error,required TResult Function( DowryListEmpty value)  empty,required TResult Function( DowryItemAdded value)  itemAdded,required TResult Function( DowryItemDeleted value)  itemDeleted,required TResult Function( DowryItemUpdated value)  itemUpdated,}){
final _that = this;
switch (_that) {
case DowryListInitial():
return initial(_that);case DowryListLoading():
return loading(_that);case DowryListLoaded():
return loaded(_that);case DowryListError():
return error(_that);case DowryListEmpty():
return empty(_that);case DowryItemAdded():
return itemAdded(_that);case DowryItemDeleted():
return itemDeleted(_that);case DowryItemUpdated():
return itemUpdated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DowryListInitial value)?  initial,TResult? Function( DowryListLoading value)?  loading,TResult? Function( DowryListLoaded value)?  loaded,TResult? Function( DowryListError value)?  error,TResult? Function( DowryListEmpty value)?  empty,TResult? Function( DowryItemAdded value)?  itemAdded,TResult? Function( DowryItemDeleted value)?  itemDeleted,TResult? Function( DowryItemUpdated value)?  itemUpdated,}){
final _that = this;
switch (_that) {
case DowryListInitial() when initial != null:
return initial(_that);case DowryListLoading() when loading != null:
return loading(_that);case DowryListLoaded() when loaded != null:
return loaded(_that);case DowryListError() when error != null:
return error(_that);case DowryListEmpty() when empty != null:
return empty(_that);case DowryItemAdded() when itemAdded != null:
return itemAdded(_that);case DowryItemDeleted() when itemDeleted != null:
return itemDeleted(_that);case DowryItemUpdated() when itemUpdated != null:
return itemUpdated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<UserItemEntity> items)?  loaded,TResult Function( String message)?  error,TResult Function( String message)?  empty,TResult Function()?  itemAdded,TResult Function()?  itemDeleted,TResult Function()?  itemUpdated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DowryListInitial() when initial != null:
return initial();case DowryListLoading() when loading != null:
return loading();case DowryListLoaded() when loaded != null:
return loaded(_that.items);case DowryListError() when error != null:
return error(_that.message);case DowryListEmpty() when empty != null:
return empty(_that.message);case DowryItemAdded() when itemAdded != null:
return itemAdded();case DowryItemDeleted() when itemDeleted != null:
return itemDeleted();case DowryItemUpdated() when itemUpdated != null:
return itemUpdated();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<UserItemEntity> items)  loaded,required TResult Function( String message)  error,required TResult Function( String message)  empty,required TResult Function()  itemAdded,required TResult Function()  itemDeleted,required TResult Function()  itemUpdated,}) {final _that = this;
switch (_that) {
case DowryListInitial():
return initial();case DowryListLoading():
return loading();case DowryListLoaded():
return loaded(_that.items);case DowryListError():
return error(_that.message);case DowryListEmpty():
return empty(_that.message);case DowryItemAdded():
return itemAdded();case DowryItemDeleted():
return itemDeleted();case DowryItemUpdated():
return itemUpdated();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<UserItemEntity> items)?  loaded,TResult? Function( String message)?  error,TResult? Function( String message)?  empty,TResult? Function()?  itemAdded,TResult? Function()?  itemDeleted,TResult? Function()?  itemUpdated,}) {final _that = this;
switch (_that) {
case DowryListInitial() when initial != null:
return initial();case DowryListLoading() when loading != null:
return loading();case DowryListLoaded() when loaded != null:
return loaded(_that.items);case DowryListError() when error != null:
return error(_that.message);case DowryListEmpty() when empty != null:
return empty(_that.message);case DowryItemAdded() when itemAdded != null:
return itemAdded();case DowryItemDeleted() when itemDeleted != null:
return itemDeleted();case DowryItemUpdated() when itemUpdated != null:
return itemUpdated();case _:
  return null;

}
}

}

/// @nodoc


class DowryListInitial implements DowryListState {
  const DowryListInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListState.initial()';
}


}




/// @nodoc


class DowryListLoading implements DowryListState {
  const DowryListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListState.loading()';
}


}




/// @nodoc


class DowryListLoaded implements DowryListState {
  const DowryListLoaded(final  List<UserItemEntity> items): _items = items;
  

 final  List<UserItemEntity> _items;
 List<UserItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of DowryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DowryListLoadedCopyWith<DowryListLoaded> get copyWith => _$DowryListLoadedCopyWithImpl<DowryListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryListLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'DowryListState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class $DowryListLoadedCopyWith<$Res> implements $DowryListStateCopyWith<$Res> {
  factory $DowryListLoadedCopyWith(DowryListLoaded value, $Res Function(DowryListLoaded) _then) = _$DowryListLoadedCopyWithImpl;
@useResult
$Res call({
 List<UserItemEntity> items
});




}
/// @nodoc
class _$DowryListLoadedCopyWithImpl<$Res>
    implements $DowryListLoadedCopyWith<$Res> {
  _$DowryListLoadedCopyWithImpl(this._self, this._then);

  final DowryListLoaded _self;
  final $Res Function(DowryListLoaded) _then;

/// Create a copy of DowryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(DowryListLoaded(
null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<UserItemEntity>,
  ));
}


}

/// @nodoc


class DowryListError implements DowryListState {
  const DowryListError(this.message);
  

 final  String message;

/// Create a copy of DowryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DowryListErrorCopyWith<DowryListError> get copyWith => _$DowryListErrorCopyWithImpl<DowryListError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DowryListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $DowryListErrorCopyWith<$Res> implements $DowryListStateCopyWith<$Res> {
  factory $DowryListErrorCopyWith(DowryListError value, $Res Function(DowryListError) _then) = _$DowryListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DowryListErrorCopyWithImpl<$Res>
    implements $DowryListErrorCopyWith<$Res> {
  _$DowryListErrorCopyWithImpl(this._self, this._then);

  final DowryListError _self;
  final $Res Function(DowryListError) _then;

/// Create a copy of DowryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DowryListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DowryListEmpty implements DowryListState {
  const DowryListEmpty(this.message);
  

 final  String message;

/// Create a copy of DowryListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DowryListEmptyCopyWith<DowryListEmpty> get copyWith => _$DowryListEmptyCopyWithImpl<DowryListEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryListEmpty&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DowryListState.empty(message: $message)';
}


}

/// @nodoc
abstract mixin class $DowryListEmptyCopyWith<$Res> implements $DowryListStateCopyWith<$Res> {
  factory $DowryListEmptyCopyWith(DowryListEmpty value, $Res Function(DowryListEmpty) _then) = _$DowryListEmptyCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$DowryListEmptyCopyWithImpl<$Res>
    implements $DowryListEmptyCopyWith<$Res> {
  _$DowryListEmptyCopyWithImpl(this._self, this._then);

  final DowryListEmpty _self;
  final $Res Function(DowryListEmpty) _then;

/// Create a copy of DowryListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(DowryListEmpty(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DowryItemAdded implements DowryListState {
  const DowryItemAdded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryItemAdded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListState.itemAdded()';
}


}




/// @nodoc


class DowryItemDeleted implements DowryListState {
  const DowryItemDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryItemDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListState.itemDeleted()';
}


}




/// @nodoc


class DowryItemUpdated implements DowryListState {
  const DowryItemUpdated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DowryItemUpdated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DowryListState.itemUpdated()';
}


}




// dart format on
