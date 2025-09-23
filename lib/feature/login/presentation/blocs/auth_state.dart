part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess(this.user);
  final User user;
}

class AuthFailure extends AuthState {
  AuthFailure(this.message);
  final String message;
}
