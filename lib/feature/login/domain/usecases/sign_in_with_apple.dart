import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';

class SignInWithApple {
  SignInWithApple(this.repository);
  final AuthRepository repository;

  Future<Either<Failure, User>> call() {
    return repository.signInWithApple();
  }
}
