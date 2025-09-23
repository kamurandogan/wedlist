import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'page_view_cubit_state.dart';

class PageViewCubit extends Cubit<PageViewCubitState> {
  PageViewCubit({required this.pageCount}) : super(const PageViewCubitState(currentIndex: 0, isLastPage: false));
  final int pageCount;

  void setPage(int index) {
    emit(PageViewCubitState(
      currentIndex: index,
      isLastPage: index == pageCount - 1,
    ));
  }

  void nextPage() {
    if (state.currentIndex < pageCount - 1) {
      setPage(state.currentIndex + 1);
    }
  }

  void previousPage() {
    if (state.currentIndex > 0) {
      setPage(state.currentIndex - 1);
    }
  }
}
