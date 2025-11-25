part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signInRequested(String email, String password) =
      SignInRequested;
  const factory AuthEvent.signInWithAppleRequested() = SignInWithAppleRequested;
  const factory AuthEvent.signInWithGoogleRequested() =
      SignInWithGoogleRequested;
}
