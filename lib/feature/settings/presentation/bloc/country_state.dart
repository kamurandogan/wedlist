part of 'country_cubit.dart';

enum CountryStatus { initial, ready, updating, error }

class CountryState {
  const CountryState({
    this.countryCode,
    this.status = CountryStatus.initial,
    this.lastMessage,
    this.wishlistInvalidated = false,
  });
  final String? countryCode;
  final CountryStatus status;
  final String? lastMessage;
  final bool wishlistInvalidated;

  CountryState copyWith({String? countryCode, CountryStatus? status, String? lastMessage, bool? wishlistInvalidated}) =>
      CountryState(
        countryCode: countryCode ?? this.countryCode,
        status: status ?? this.status,
        lastMessage: lastMessage ?? this.lastMessage,
        wishlistInvalidated: wishlistInvalidated ?? this.wishlistInvalidated,
      );
}
