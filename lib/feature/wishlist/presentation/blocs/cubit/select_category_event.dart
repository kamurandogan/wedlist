part of 'select_category_cubit.dart';

abstract class SelectCategoryEvent {}

class FetchWishListItems extends SelectCategoryEvent {
  FetchWishListItems(this.list);
  final List<String> list;
}
