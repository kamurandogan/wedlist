import 'package:bloc/bloc.dart';

class SelectCategoryCubit extends Cubit<String> {
  SelectCategoryCubit() : super('Bedroom');

  void selectCategory(String category) {
    emit(category);
  }
}
