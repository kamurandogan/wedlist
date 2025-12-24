import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/watch_user_items_usecase.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';

part 'wishlist_bloc.freezed.dart';
part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  WishListBloc(
    this.getWishListItems,
    this._refreshBus,
    this._watchUserItemsUseCase,
  ) : super(const WishListState.initial()) {
    on<FetchWishListItems>(_onFetch);
    on<WatchWishListItems>(_onWatch);

    // Ülke değiştiğinde yeni ülke koduyla otomatik refresh
    _sub = _refreshBus.stream.listen((evt) {
      if (evt.type == RefreshEventType.countryChanged && _lastParams != null) {
        // Yeni ülke kodunu kullan, eğer yoksa eski langCode'u kullan
        final newLangCode =
            evt.countryCode?.toLowerCase() ?? _lastParams!.langCode;
        add(
          WishListEvent.watch(
            _lastParams!.category,
            newLangCode,
            _lastParams!.id,
          ),
        );
      }
    });

    // DowryList (UserItems) değiştiğinde _currentUserItems'i güncelle
    // ve eğer wishlist loaded state'indeyse, filtrelemeyi yeniden yap
    _dowrySub = _watchUserItemsUseCase().listen((items) {
      _currentUserItems = items;

      // Eğer mevcut state loaded ise ve elimizde wishlist verileri varsa,
      // yeniden filtreleme yapıp emit et (Watch event tetiklemeden)
      if (state is _Loaded && _lastWishItems.isNotEmpty) {
        final filteredItems = _filterItems(_lastWishItems);
        emit(WishListState.loaded(filteredItems));
      }
    });
  }

  final GetWishListItems getWishListItems;
  final RefreshBus _refreshBus;
  final WatchUserItemsUseCase _watchUserItemsUseCase;

  StreamSubscription<RefreshEvent>? _sub;
  StreamSubscription<List<UserItemEntity>>? _dowrySub;

  _FetchParams? _lastParams;
  List<UserItemEntity> _currentUserItems = [];
  List<ItemEntity> _lastWishItems = [];

  Future<void> _onFetch(
    FetchWishListItems event,
    Emitter<WishListState> emit,
  ) async {
    emit(const WishListState.loading());
    _lastParams = _FetchParams(event.category, event.langCode, event.id);

    // Önce güncel user items'ı alalım (cache'den veya stream'den ilk değer)
    // _currentUserItems zaten stream listener ile güncel tutuluyor.

    final result = await getWishListItems.call(
      event.category,
      event.langCode,
      event.id,
    );

    result.fold(
      (failure) => emit(WishListState.error(_failureToMessage(failure))),
      (items) {
        // Ham wishlist verilerini sakla (filtering için gerekli)
        _lastWishItems = items;
        final filteredItems = _filterItems(items);
        emit(WishListState.loaded(filteredItems));
      },
    );
  }

  Future<void> _onWatch(
    WatchWishListItems event,
    Emitter<WishListState> emit,
  ) async {
    emit(const WishListState.loading());
    _lastParams = _FetchParams(event.category, event.langCode, event.id);

    // Wishlist stream'ini dinle
    await emit.forEach<Either<Failure, List<ItemEntity>>>(
      getWishListItems.stream(event.category, event.langCode, event.id),
      onData: (either) {
        return either.fold(
          (failure) => WishListState.error(_failureToMessage(failure)),
          (items) {
            // Ham wishlist verilerini sakla (filtering için gerekli)
            _lastWishItems = items;
            final filteredItems = _filterItems(items);
            return WishListState.loaded(filteredItems);
          },
        );
      },
    );
  }

  List<ItemEntity> _filterItems(List<ItemEntity> wishItems) {
    // Helper: case-insensitive key oluştur
    String keyOf(String category, String title) =>
        '${category.trim().toLowerCase()}|${title.trim().toLowerCase()}';

    final ownedKeys = <String>{};
    for (final u in _currentUserItems) {
      ownedKeys.add(keyOf(u.category, u.title));
    }

    // Filtrele: owned olmayan item'ları al
    final filtered = ownedKeys.isEmpty
        ? wishItems
        : wishItems
              .where((w) => !ownedKeys.contains(keyOf(w.category, w.title)))
              .toList();

    // Deduplication
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
