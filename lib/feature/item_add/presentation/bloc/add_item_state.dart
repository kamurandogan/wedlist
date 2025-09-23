part of 'add_item_bloc.dart';

abstract class AddItemState {}

class AddItemInitial extends AddItemState {}

class AddItemLoading extends AddItemState {}

class AddItemSuccess extends AddItemState {}

class AddItemFailure extends AddItemState {
  AddItemFailure(this.message);
  final String message;
}
