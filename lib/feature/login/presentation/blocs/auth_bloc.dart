import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedlist/core/user/country_persistence.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_apple.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_google.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this.signIn,
    this._countryService,
    this.signInWithApple,
    this.signInWithGoogle,
  ) : super(const AuthState.initial()) {
    on<SignInRequested>((event, emit) async {
      emit(const AuthState.loading());
      final result = await signIn(event.email, event.password);
      await result.fold(
        (failure) async => emit(AuthState.failure(failure.message ?? 'Giriş başarısız.')),
        (user) async {
          await _countryService.syncSelectedCountryIfAny();
          emit(AuthState.success(user));
        },
      );
    });

    on<SignInWithAppleRequested>((event, emit) async {
      emit(const AuthState.loading());
      final result = await signInWithApple();
      await result.fold(
        (failure) async => emit(AuthState.failure(failure.message ?? 'Apple ile giriş başarısız.')),
        (user) async {
          await _countryService.syncSelectedCountryIfAny();
          emit(AuthState.success(user));
        },
      );
    });

    on<SignInWithGoogleRequested>((event, emit) async {
      emit(const AuthState.loading());
      final result = await signInWithGoogle();
      await result.fold(
        (failure) async =>
            emit(AuthState.failure(failure.message ?? 'Google ile giriş başarısız.')),
        (user) async {
          await _countryService.syncSelectedCountryIfAny();
          emit(AuthState.success(user));
        },
      );
    });
  }

  final SignIn signIn;
  final CountryPersistenceService _countryService;
  final SignInWithApple signInWithApple;
  final SignInWithGoogle signInWithGoogle;
}
