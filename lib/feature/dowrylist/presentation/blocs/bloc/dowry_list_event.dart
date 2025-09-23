part of 'dowry_list_bloc.dart';

@immutable
sealed class DowryListEvent {}

class FetchDowryListItems extends DowryListEvent {
  FetchDowryListItems();
}

class DeleteDowryItem extends DowryListEvent {
  DeleteDowryItem(this.id);
  final String id;
}

class UpdateDowryItem extends DowryListEvent {
  UpdateDowryItem(this.updatedItem);
  final UserItemEntity updatedItem;
}

class SubscribeDowryItems extends DowryListEvent {}

class _OptimisticInsert extends DowryListEvent {
  _OptimisticInsert(this.item);
  final UserItemEntity item;
}

class _DowryItemsStreamUpdated extends DowryListEvent {
  _DowryItemsStreamUpdated(this.items);
  final List<UserItemEntity> items;
}
