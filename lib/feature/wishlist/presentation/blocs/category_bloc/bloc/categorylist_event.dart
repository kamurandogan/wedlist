part of 'categorylist_bloc.dart';

@immutable
sealed class CategorylistEvent {}

final class FetchCategoryList extends CategorylistEvent {
  FetchCategoryList(this.langCode, this.category);
  final String langCode;
  final String category;
}

final class AddCustomCategory extends CategorylistEvent {
  AddCustomCategory(this.name);
  final String name;
}
