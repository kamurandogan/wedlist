import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';

class SignIn {
  SignIn(this.repository);
  final AuthRepository repository;

  Future<Either<Failure, User>> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
