part of 'wishlist_bloc.dart';

@freezed
sealed class WishListEvent with _$WishListEvent {
  /// One-time fetch (existing - for backward compatibility)
  const factory WishListEvent.fetch(
    String category,
    String langCode,
    String id,
  ) = FetchWishListItems;

  /// ⚡ Real-time stream watch (NEW - for reactive updates)
  const factory WishListEvent.watch(
    String category,
    String langCode,
    String id,
  ) = WatchWishListItems;
}
