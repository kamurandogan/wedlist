part of 'wishlist_bloc.dart';

abstract class WishListEvent {}

class FetchWishListItems extends WishListEvent {
  FetchWishListItems(this.category, this.langCode, this.id);
  final String category;
  final String langCode;
  final String id;
}
