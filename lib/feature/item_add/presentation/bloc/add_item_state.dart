part of 'add_item_bloc.dart';

@freezed
class AddItemState with _$AddItemState {
  const factory AddItemState.initial() = AddItemInitial;
  const factory AddItemState.loading() = AddItemLoading;
  const factory AddItemState.success() = AddItemSuccess;
  const factory AddItemState.failure(String message) = AddItemFailure;
}
