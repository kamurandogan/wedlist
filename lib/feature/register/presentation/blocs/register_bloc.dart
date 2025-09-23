import 'package:bloc/bloc.dart';
import 'package:wedlist/feature/register/domain/entities/register_entity.dart';
import 'package:wedlist/feature/register/domain/usecases/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.registerUseCase) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        await registerUseCase(event.entity);
        emit(RegisterSuccess());
      } on Exception catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
  final RegisterUseCase registerUseCase;
}
