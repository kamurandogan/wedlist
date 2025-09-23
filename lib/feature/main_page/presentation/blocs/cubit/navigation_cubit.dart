import 'package:bloc/bloc.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<SelectedPage> {
  NavigationCubit() : super(SelectedPage.home);

  // Method to change the selected page
  // This method will be called when the user taps on a bottom navigation item
  // It takes a SelectedPage enum value as an argument and emits it as the new state
  void changePage(SelectedPage page) => emit(page);
}
