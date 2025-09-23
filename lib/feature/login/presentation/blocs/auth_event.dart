part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInRequested extends AuthEvent {

  SignInRequested(this.email, this.password);
  final String email;
  final String password;
}
