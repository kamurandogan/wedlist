import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';

part 'wishlist_bloc.freezed.dart';
part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  WishListBloc(
    this.getWishListItems,
    this._refreshBus,
    this._dowryListBloc,
  ) : super(const WishListState.initial()) {
    on<FetchWishListItems>(_onFetch);
    on<WatchWishListItems>(_onWatch); // ⚡ NEW: Stream-based watch

    // Ülke değiştiğinde son parametrelerle otomatik refresh
    _sub = _refreshBus.stream.listen((evt) {
      if (evt.type == RefreshEventType.countryChanged && _lastParams != null) {
        // ⚡ Stream-based watch kullan
        add(
          WishListEvent.watch(
            _lastParams!.category,
            _lastParams!.langCode,
            _lastParams!.id,
          ),
        );
      }
    });

    // DowryListBloc değiştiğinde filtering'i yeniden yap
    _dowrySub = _dowryListBloc.stream.listen((_) {
      if (_lastParams != null) {
        state.maybeWhen(
          loaded: (_) {
            // ⚡ Stream-based watch kullan
            add(
              WishListEvent.watch(
                _lastParams!.category,
                _lastParams!.langCode,
                _lastParams!.id,
              ),
            );
          },
          orElse: () {},
        );
      }
    });
  }
  final GetWishListItems getWishListItems;
  final RefreshBus _refreshBus;
  final DowryListBloc _dowryListBloc;
  StreamSubscription<RefreshEvent>? _sub;
  StreamSubscription<DowryListState>? _dowrySub;
  _FetchParams? _lastParams;

  /// One-time fetch (existing method)
  Future<void> _onFetch(
    FetchWishListItems event,
    Emitter<WishListState> emit,
  ) async {
    emit(const WishListState.loading());
    _lastParams = _FetchParams(event.category, event.langCode, event.id);

    final result = await getWishListItems.call(
      event.category,
      event.langCode,
      event.id,
    );

    result.fold(
      (failure) => emit(WishListState.error(_failureToMessage(failure))),
      (items) {
        final filteredItems = _filterItems(items);
        emit(WishListState.loaded(filteredItems));
      },
    );
  }

  /// ⚡ Real-time stream watch (NEW - ChatGPT sohbetindeki emit.forEach kullanımı)
  Future<void> _onWatch(
    WatchWishListItems event,
    Emitter<WishListState> emit,
  ) async {
    emit(const WishListState.loading());
    _lastParams = _FetchParams(event.category, event.langCode, event.id);

    // 🔥 Stream<Either<Failure, List<ItemEntity>>> kullanımı
    await emit.forEach<Either<Failure, List<ItemEntity>>>(
      getWishListItems.stream(event.category, event.langCode, event.id),
      onData: (either) {
        return either.fold(
          (failure) => WishListState.error(_failureToMessage(failure)),
          (items) {
            final filteredItems = _filterItems(items);
            return WishListState.loaded(filteredItems);
          },
        );
      },
    );
  }

  /// Wishlist item'larını filtreler: DowryList'te olanları çıkarır
  List<ItemEntity> _filterItems(List<ItemEntity> wishItems) {
    final dowryState = _dowryListBloc.state;

    // Helper: case-insensitive key oluştur
    String keyOf(String category, String title) =>
        '${category.trim().toLowerCase()}|${title.trim().toLowerCase()}';

    // DowryList'teki item'ların key'lerini topla
    final ownedKeys = <String>{};
    dowryState.maybeWhen(
      loaded: (items) {
        for (final u in items) {
          ownedKeys.add(keyOf(u.category, u.title));
        }
      },
      orElse: () {},
    );

    // Filtrele: owned olmayan item'ları al
    final filtered = ownedKeys.isEmpty
        ? wishItems
        : wishItems
              .where((w) => !ownedKeys.contains(keyOf(w.category, w.title)))
              .toList();

    // Deduplication: Aynı category+title'dan birden fazla varsa sadece birini al
    String norm(String s) => s.trim().toLowerCase();
    final byKey = <String, ItemEntity>{};
    for (final w in filtered) {
      final k = '${norm(w.category)}|${norm(w.title)}';
      byKey.putIfAbsent(k, () => w);
    }

    return byKey.values.toList();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _dowrySub?.cancel();
    return super.close();
  }

  String _failureToMessage(Failure failure) {
    return failure.toString();
  }
}

class _FetchParams {
  _FetchParams(this.category, this.langCode, this.id);
  final String category;
  final String langCode;
  final String id;
}
