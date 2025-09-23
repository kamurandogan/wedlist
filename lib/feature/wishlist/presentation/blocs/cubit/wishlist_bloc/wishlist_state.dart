part of 'wishlist_bloc.dart';

abstract class WishListState {}

class WishListInitial extends WishListState {}

class WishListLoading extends WishListState {}

class WishListLoaded extends WishListState {
  WishListLoaded(this.items);
  final List<ItemEntity> items;
}

class WishListError extends WishListState {
  WishListError(this.message);
  final String message;
}
