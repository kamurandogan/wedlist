import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message, [this.stackTrace]);
  final String message;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => <Object?>[message];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, [super.stackTrace]);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.stackTrace]);
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, [super.stackTrace]);
}
