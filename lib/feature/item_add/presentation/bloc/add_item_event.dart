part of 'add_item_bloc.dart';

@freezed
sealed class AddItemEvent with _$AddItemEvent {
  const factory AddItemEvent.addItemButtonPressed({
    required String title,
    required String category,
    String? id,
    String? price,
    String? note,
    String? imgUrl,
  }) = AddItemButtonPressed;
}
