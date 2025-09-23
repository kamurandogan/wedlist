part of 'add_item_bloc.dart';

abstract class AddItemEvent {}

class AddItemButtonPressed extends AddItemEvent {
  AddItemButtonPressed({
    required this.title,
    required this.category,
    this.id,
    this.price,
    this.note,
    this.imgUrl,
  });
  final String? id;
  final String title;
  final String category;
  final String? price;
  final String? note;
  final String? imgUrl;
}
