part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  RegisterSubmitted(this.entity);
  final RegisterEntity entity;
}
