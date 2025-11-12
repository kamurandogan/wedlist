part of 'wishlist_bloc.dart';

abstract class WishListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// One-time fetch (existing - for backward compatibility)
class FetchWishListItems extends WishListEvent {
  FetchWishListItems(this.category, this.langCode, this.id);
  final String category;
  final String langCode;
  final String id;

  @override
  List<Object?> get props => [category, langCode, id];
}

/// ⚡ Real-time stream watch (NEW - for reactive updates)
class WatchWishListItems extends WishListEvent {
  WatchWishListItems(this.category, this.langCode, this.id);
  final String category;
  final String langCode;
  final String id;

  @override
  List<Object?> get props => [category, langCode, id];
}
