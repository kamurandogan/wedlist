import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_category_items.dart';

part 'categorylist_event.dart';
part 'categorylist_state.dart';

class CategorylistBloc extends Bloc<CategorylistEvent, CategorylistState> {
  CategorylistBloc(this.getCategoryListItems, this._refreshBus)
    : super(CategorylistInitial()) {
    on<FetchCategoryList>(_onFetch);
    on<AddCustomCategory>(_onAddCustom);

    _sub = _refreshBus.stream.listen((evt) {
      if (evt.type == RefreshEventType.countryChanged && _lastParams != null) {
        add(FetchCategoryList(_lastParams!.category, _lastParams!.langCode));
      }
    });
  }
  final GetCategoryItems getCategoryListItems;
  final RefreshBus _refreshBus;
  StreamSubscription<RefreshEvent>? _sub;
  _CategoryFetchParams? _lastParams;

  Future<void> _onFetch(
    FetchCategoryList event,
    Emitter<CategorylistState> emit,
  ) async {
    emit(CategorylistLoading());
    try {
      _lastParams = _CategoryFetchParams(event.category, event.langCode);
      final items = await getCategoryListItems.call(
        event.category,
        event.langCode,
      );
      emit(CategorylistLoaded(items));
    } on FirebaseException catch (e) {
      emit(CategorylistError(_firebaseErrorToMessage(e)));
    } on Exception catch (e) {
      emit(CategorylistError(e.toString()));
    }
  }

  Future<void> _onAddCustom(
    AddCustomCategory event,
    Emitter<CategorylistState> emit,
  ) async {
    final current = state;
    if (current is CategorylistLoaded) {
      final exists = current.items.any(
        (e) => e.title.toLowerCase() == event.name.toLowerCase(),
      );
      if (exists) return; // ignore duplicates
      final updated = List<CategoryItem>.from(current.items)
        ..add(CategoryItem(event.name));
      emit(CategorylistLoaded(updated));
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
        return 'Kategorileri görüntüleme yetkiniz yok. Lütfen oturum açın veya erişim izninizi kontrol edin.';
      case 'unavailable':
        return 'Hizmet geçici olarak kullanılamıyor. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.';
      case 'cancelled':
        return 'İşlem iptal edildi. Lütfen tekrar deneyin.';
      default:
        return e.message ?? 'Bir hata oluştu.';
    }
  }
}

class _CategoryFetchParams {
  _CategoryFetchParams(this.category, this.langCode);
  final String category;
  final String langCode;
}
