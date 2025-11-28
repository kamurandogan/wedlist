import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/delete_user_item_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/get_user_items_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/update_user_item_usecase.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/watch_user_items_usecase.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/injection_container.dart';

part 'dowry_list_bloc.freezed.dart';
part 'dowry_list_event.dart';
part 'dowry_list_state.dart';

class DowryListBloc extends Bloc<DowryListEvent, DowryListState> {
  DowryListBloc(
    this.getUserItems,
    this.deleteUserItem,
    this.updateUserItem,
    this.watchUserItems,
  ) : super(const DowryListState.initial()) {
    on<FetchDowryListItems>(_fetchItems);
    on<DeleteDowryItem>(_deleteItem);
    on<UpdateDowryItem>(_updateItem);
    on<SubscribeDowryItems>(_subscribe);
    on<_DowryItemsStreamUpdated>(_onStreamUpdated);
    on<_OptimisticInsert>(_onOptimisticInsert);
  }
  final GetUserItemsUseCase getUserItems;
  final DeleteUserItemUseCase deleteUserItem;
  final UpdateUserItemUseCase updateUserItem;
  final WatchUserItemsUseCase watchUserItems;
  StreamSubscription<List<UserItemEntity>>? _sub;

  Future<void> _fetchItems(
    FetchDowryListItems event,
    Emitter<DowryListState> emit,
  ) async {
    emit(const DowryListState.loading());
    final result = await getUserItems();
    result.fold(
      (l) => emit(DowryListState.error(l.message ?? 'Bir hata oluştu')),
      (items) => items.isEmpty
          ? emit(const DowryListState.empty('Liste boş'))
          : emit(DowryListState.loaded(items)),
    );
  }

  void optimisticAdd(UserItemEntity item) {
    add(DowryListEvent.optimisticInsert(item));
  }

  void _onOptimisticInsert(
    _OptimisticInsert event,
    Emitter<DowryListState> emit,
  ) {
    state.maybeMap(
      loaded: (state) {
        final existing = state.items;
        if (existing.any((e) => e.id == event.item.id)) return;
        final updated = [event.item, ...existing];
        emit(DowryListState.loaded(updated));
      },
      empty: (_) {
        emit(DowryListState.loaded([event.item]));
      },
      orElse: () {},
    );
  }

  Future<void> _deleteItem(
    DeleteDowryItem event,
    Emitter<DowryListState> emit,
  ) async {
    final res = await deleteUserItem(event.id);
    res.fold(
      (l) => emit(DowryListState.error(l.message ?? 'Bir hata oluştu')),
      (_) async {
        add(const DowryListEvent.fetchDowryListItems());
        try {
          await sl<UserService>().ensureUserItemsSymmetric();
        } on Exception catch (_) {
          // Sessizce yut
        }
      },
    );
  }

  Future<void> _updateItem(
    UpdateDowryItem event,
    Emitter<DowryListState> emit,
  ) async {
    final res = await updateUserItem(event.updatedItem);
    res.fold(
      (l) => emit(DowryListState.error(l.message ?? 'Bir hata oluştu')),
      (_) async => add(const DowryListEvent.fetchDowryListItems()),
    );
  }

  Future<void> _subscribe(
    SubscribeDowryItems event,
    Emitter<DowryListState> emit,
  ) async {
    await _sub?.cancel();
    emit(const DowryListState.loading());
    _sub = watchUserItems().listen(
      (items) => add(DowryListEvent.dowryItemsStreamUpdated(items)),
      onError: (Object e, StackTrace _) =>
          emit(DowryListState.error(e.toString())),
    );
  }

  void _onStreamUpdated(
    _DowryItemsStreamUpdated event,
    Emitter<DowryListState> emit,
  ) {
    if (event.items.isEmpty) {
      emit(const DowryListState.empty('Liste boş'));
    } else {
      emit(DowryListState.loaded(event.items));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
