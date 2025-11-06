import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  WishListBloc(
    this.getWishListItems,
    this._refreshBus,
    this._dowryListBloc,
  ) : super(WishListInitial()) {
    on<FetchWishListItems>(_onFetch);

    // Ülke değiştiğinde son parametrelerle otomatik refresh
    _sub = _refreshBus.stream.listen((evt) {
      if (evt.type == RefreshEventType.countryChanged && _lastParams != null) {
        add(
          FetchWishListItems(
            _lastParams!.category,
            _lastParams!.langCode,
            _lastParams!.id,
          ),
        );
      }
    });

    // DowryListBloc değiştiğinde filtering'i yeniden yap
    _dowrySub = _dowryListBloc.stream.listen((_) {
      if (_lastParams != null && state is WishListLoaded) {
        add(
          FetchWishListItems(
            _lastParams!.category,
            _lastParams!.langCode,
            _lastParams!.id,
          ),
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

  Future<void> _onFetch(
    FetchWishListItems event,
    Emitter<WishListState> emit,
  ) async {
    emit(WishListLoading());
    try {
      _lastParams = _FetchParams(event.category, event.langCode, event.id);
      final items = await getWishListItems.call(
        event.category,
        event.langCode,
        event.id,
      );

      // Filtering logic: DowryList'teki item'ları wishlist'ten çıkar
      final filteredItems = _filterItems(items);

      emit(WishListLoaded(filteredItems));
    } on FirebaseException catch (e) {
      emit(WishListError(_firebaseErrorToMessage(e)));
    } on Exception catch (e) {
      emit(WishListError('Veriler yüklenemedi  : $e'));
    }
  }

  /// Wishlist item'larını filtreler: DowryList'te olanları çıkarır
  List<ItemEntity> _filterItems(List<ItemEntity> wishItems) {
    final dowryState = _dowryListBloc.state;

    // Helper: case-insensitive key oluştur
    String keyOf(String category, String title) =>
        '${category.trim().toLowerCase()}|${title.trim().toLowerCase()}';

    // DowryList'teki item'ların key'lerini topla
    final ownedKeys = <String>{};
    if (dowryState is DowryListLoaded) {
      for (final u in dowryState.items) {
        ownedKeys.add(keyOf(u.category, u.title));
      }
    }

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

  String _firebaseErrorToMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Bu içerik için yetkiniz yok. Lütfen oturum açtığınızdan ve erişim izniniz olduğundan emin olun.';
      case 'unavailable':
        return 'Hizmet geçici olarak kullanılamıyor. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.';
      case 'cancelled':
        return 'İşlem iptal edildi. Lütfen tekrar deneyin.';
      case 'not-found':
        return 'Kayıt bulunamadı.';
      default:
        return e.message ?? 'Bir hata oluştu.';
    }
  }
}

class _FetchParams {
  _FetchParams(this.category, this.langCode, this.id);
  final String category;
  final String langCode;
  final String id;
}
