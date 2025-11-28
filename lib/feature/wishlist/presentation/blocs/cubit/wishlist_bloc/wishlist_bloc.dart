import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/watch_user_items_usecase.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
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

    // Ülke değiştiğinde son parametrelerle otomatik refresh
    _sub = _refreshBus.stream.listen((evt) {
      if (evt.type == RefreshEventType.countryChanged && _lastParams != null) {
        add(
          WishListEvent.watch(
            _lastParams!.category,
            _lastParams!.langCode,
            _lastParams!.id,
          ),
        );
      }
    });

    // DowryList (UserItems) değiştiğinde filtering'i yeniden yap
    // WatchUserItemsUseCase stream'ini dinle
    _dowrySub = _watchUserItemsUseCase().listen((items) {
      _currentUserItems = items;
      // Eğer hali hazırda yüklü bir liste varsa, filtrelemeyi güncelle
      state.maybeWhen(
        loaded: (_) {
          if (_lastParams != null) {
            // Mevcut parametrelerle yeniden watch tetikle veya
            // sadece filtrelemeyi güncellemek daha verimli olabilir ama
            // şimdilik tutarlılık için watch event'ini tekrar tetikleyelim
            // ya da direkt emit yapabiliriz ama stream-based watch olduğu için
            // _onWatch içindeki combine logic daha doğru olur.
            // ANCAK: _onWatch zaten stream dinliyor.
            // BURADA STRATEJİ DEĞİŞİKLİĞİ:
            // _onWatch metodunda Rx.combineLatest gibi bir yapı kurmak en temizidir.
            // Fakat flutter_bloc ile bu biraz manuel.
            // Basit çözüm: UserItems değiştiğinde, mevcut state loaded ise
            // ve elimizde ham veri (raw wish items) yoksa tekrar fetch/watch yapmak.
            // Ama biz _onWatch içinde emit.forEach kullanıyoruz.
            // Bu yüzden _dowrySub burada sadece tetikleyici olabilir.

            // DAHA İYİ ÇÖZÜM:
            // _onWatch metodunu hem wishlist stream'ini hem de user items stream'ini
            // dinleyecek şekilde combine edelim.
            // Bu durumda buradaki _dowrySub'a gerek kalmayabilir veya
            // sadece refresh bus mantığı kalır.

            // Şimdilik mevcut yapıyı bozmadan:
            // UserItems güncellendiğinde, _currentUserItems'i güncelle ve
            // eğer _lastParams varsa yeniden Watch event'i at.
            // Bu biraz maliyetli olabilir (tekrar API call vs. stream restart).
            // Ama en garantisi bu.
            add(
              WishListEvent.watch(
                _lastParams!.category,
                _lastParams!.langCode,
                _lastParams!.id,
              ),
            );
          }
        },
        orElse: () {},
      );
    });
  }

  final GetWishListItems getWishListItems;
  final RefreshBus _refreshBus;
  final WatchUserItemsUseCase _watchUserItemsUseCase;

  StreamSubscription<RefreshEvent>? _sub;
  StreamSubscription<List<UserItemEntity>>? _dowrySub;

  _FetchParams? _lastParams;
  List<UserItemEntity> _currentUserItems = [];

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
