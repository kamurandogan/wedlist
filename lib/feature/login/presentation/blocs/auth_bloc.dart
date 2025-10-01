import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/user/country_persistence.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_apple.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_google.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this.signIn,
    this._countryService,
    this.signInWithApple,
    this.signInWithGoogle,
  ) : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signIn(event.email, event.password);
        if (user != null) {
          // Persist onboarding-selected country (if any) to Firestore once user is authenticated.
          await _countryService.syncSelectedCountryIfAny();
          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure('Giriş başarısız.'));
        }
      } on Exception catch (e) {
        emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });

    on<SignInWithAppleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithApple();
        if (user != null) {
          await _countryService.syncSelectedCountryIfAny();
          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure('Giriş başarısız.'));
        }
      } on Exception catch (e) {
        emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });

    on<SignInWithGoogleRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await signInWithGoogle();
        if (user != null) {
          await _countryService.syncSelectedCountryIfAny();
          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure('Giriş başarısız.'));
        }
      } on Exception catch (e) {
        emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });
  }
  final SignIn signIn;
  final CountryPersistenceService _countryService;
  final SignInWithApple signInWithApple;
  final SignInWithGoogle signInWithGoogle;
}
