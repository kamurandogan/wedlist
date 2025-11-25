part of 'dowry_list_bloc.dart';

@freezed
class DowryListState with _$DowryListState {
  const factory DowryListState.initial() = DowryListInitial;
  const factory DowryListState.loading() = DowryListLoading;
  const factory DowryListState.loaded(List<UserItemEntity> items) =
      DowryListLoaded;
  const factory DowryListState.error(String message) = DowryListError;
  const factory DowryListState.empty(String message) = DowryListEmpty;
  const factory DowryListState.itemAdded() = DowryItemAdded;
  const factory DowryListState.itemDeleted() = DowryItemDeleted;
  const factory DowryListState.itemUpdated() = DowryItemUpdated;
}
