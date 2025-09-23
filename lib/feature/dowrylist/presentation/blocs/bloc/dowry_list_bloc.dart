import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/delete_user_item_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/get_user_items_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/update_user_item_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/watch_user_items_usecase.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/injection_container.dart';

part 'dowry_list_event.dart';
part 'dowry_list_state.dart';

class DowryListBloc extends Bloc<DowryListEvent, DowryListState> {
  DowryListBloc(
    this.getUserItems,
    this.deleteUserItem,
    this.updateUserItem,
    this.watchUserItems,
  ) : super(DowryListInitial()) {
    on<DeleteDowryItem>(_deleteItem);
    on<UpdateDowryItem>(_updateItem);
    on<FetchDowryListItems>(_fetchItems);
    on<SubscribeDowryItems>(_subscribe);
    on<_DowryItemsStreamUpdated>(_onStreamUpdated);
    on<_OptimisticInsert>(_onOptimisticInsert);
  }
  final GetUserItemsUseCase getUserItems;
  final DeleteUserItemUseCase deleteUserItem;
  final UpdateUserItemUseCase updateUserItem;
  final WatchUserItemsUseCase watchUserItems;
  StreamSubscription<List<UserItemEntity>>? _sub;

  // Firestore'dan listeyi çekme fonksiyonu
  Future<void> _fetchItems(
    FetchDowryListItems event,
    Emitter<DowryListState> emit,
  ) async {
    emit(DowryListLoading());
    final result = await getUserItems();
    result.match(
      (l) => emit(DowryListError(l.message)),
      (items) => items.isEmpty
          ? emit(DowryListEmpty('Liste boş'))
          : emit(DowryListLoaded(items)),
    );
  }

  void optimisticAdd(UserItemEntity item) {
    add(_OptimisticInsert(item));
  }

  void _onOptimisticInsert(
    _OptimisticInsert event,
    Emitter<DowryListState> emit,
  ) {
    final current = state;
    if (current is DowryListLoaded) {
      final existing = current.items;
      if (existing.any((e) => e.id == event.item.id)) return; // already present
      final updated = [event.item, ...existing];
      emit(DowryListLoaded(updated));
    } else if (current is DowryListEmpty) {
      emit(DowryListLoaded([event.item]));
    }
  }

  Future<void> _deleteItem(
    DeleteDowryItem event,
    Emitter<DowryListState> emit,
  ) async {
    final res = await deleteUserItem(event.id);
    res.match(
      (l) => emit(DowryListError(l.message)),
      (_) async {
        add(FetchDowryListItems());
        // Silme sonrası sahiplik simetrisini tekrar doğrula (partner eşitleme)
        try {
          await sl<UserService>().ensureUserItemsSymmetric();
        } on Exception catch (_) {
          // Sessizce yut: kritik değil
        }
      },
    );
  }

  Future<void> _updateItem(
    UpdateDowryItem event,
    Emitter<DowryListState> emit,
  ) async {
    final res = await updateUserItem(event.updatedItem);
    res.match(
      (l) => emit(DowryListError(l.message)),
      (_) async => add(FetchDowryListItems()),
    );
  }

  Future<void> _subscribe(
    SubscribeDowryItems event,
    Emitter<DowryListState> emit,
  ) async {
    await _sub?.cancel();
    emit(DowryListLoading());
    _sub = watchUserItems().listen(
      (items) => add(_DowryItemsStreamUpdated(items)),
      onError: (Object e, StackTrace _) => emit(DowryListError(e.toString())),
    );
  }

  void _onStreamUpdated(
    _DowryItemsStreamUpdated event,
    Emitter<DowryListState> emit,
  ) {
    if (event.items.isEmpty) {
      emit(DowryListEmpty('Liste boş'));
    } else {
      emit(DowryListLoaded(event.items));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  // Future<void> _addItem(AddDowryItem event, Emitter<DowryListState> emit) async {
  //   try {
  //     firestore.collection('userList').doc('Mutfak').set(event.newItem.toJson());
  //   } catch (e) {
  //     emit(DowryListError(e.toString()));
  //   }
  // }
}
