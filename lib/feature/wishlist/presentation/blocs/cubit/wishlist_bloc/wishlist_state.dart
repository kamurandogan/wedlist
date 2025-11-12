part of 'wishlist_bloc.dart';

@freezed
class WishListState with _$WishListState {
  const factory WishListState.initial() = _Initial;
  const factory WishListState.loading() = _Loading;
  const factory WishListState.loaded(List<ItemEntity> items) = _Loaded;
  const factory WishListState.error(String message) = _Error;
}
