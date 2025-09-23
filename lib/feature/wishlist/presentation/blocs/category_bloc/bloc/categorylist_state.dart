part of 'categorylist_bloc.dart';

@immutable
sealed class CategorylistState {}

final class CategorylistInitial extends CategorylistState {}

final class CategorylistLoading extends CategorylistState {}

final class CategorylistLoaded extends CategorylistState {

  CategorylistLoaded(this.items);
  final List<CategoryItem> items;
}

final class CategorylistError extends CategorylistState {

  CategorylistError(this.message);
  final String message;
}
