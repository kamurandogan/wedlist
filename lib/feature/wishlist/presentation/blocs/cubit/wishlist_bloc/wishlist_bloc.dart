import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  WishListBloc(this.getWishListItems, this._refreshBus)
    : super(WishListInitial()) {
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
  }
  final GetWishListItems getWishListItems;
  final RefreshBus _refreshBus;
  StreamSubscription<RefreshEvent>? _sub;
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
      emit(WishListLoaded(items));
    } on FirebaseException catch (e) {
      emit(WishListError(_firebaseErrorToMessage(e)));
    } on Exception catch (e) {
      emit(WishListError('Veriler yüklenemedi  : $e'));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
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
