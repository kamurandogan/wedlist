part of 'dowry_list_bloc.dart';

@freezed
class DowryListEvent with _$DowryListEvent {
  const factory DowryListEvent.fetchDowryListItems() = FetchDowryListItems;
  const factory DowryListEvent.deleteDowryItem(String id) = DeleteDowryItem;
  const factory DowryListEvent.updateDowryItem(UserItemEntity updatedItem) =
      UpdateDowryItem;
  const factory DowryListEvent.subscribeDowryItems() = SubscribeDowryItems;
  const factory DowryListEvent.optimisticInsert(UserItemEntity item) =
      _OptimisticInsert;
  const factory DowryListEvent.dowryItemsStreamUpdated(
    List<UserItemEntity> items,
  ) = _DowryItemsStreamUpdated;
}
