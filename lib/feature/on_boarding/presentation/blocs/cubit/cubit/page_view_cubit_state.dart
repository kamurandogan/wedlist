part of 'page_view_cubit.dart';

@immutable
class PageViewCubitState {
  const PageViewCubitState({
    required this.currentIndex,
    required this.isLastPage,
  });
  final int currentIndex;
  final bool isLastPage;
}
