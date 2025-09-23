part of 'dowry_list_bloc.dart';

@immutable
sealed class DowryListState {}

final class DowryListInitial extends DowryListState {}

final class DowryListLoading extends DowryListState {}

final class DowryListLoaded extends DowryListState {
  DowryListLoaded(this.items);
  final List<UserItemEntity> items;
}

final class DowryListError extends DowryListState {
  DowryListError(this.message);
  final String message;
}

final class DowryListEmpty extends DowryListState {
  DowryListEmpty(this.message);
  final String message;
}

final class DowryItemAdded extends DowryListState {}

final class DowryItemDeleted extends DowryListState {}

final class DowryItemUpdated extends DowryListState {}
