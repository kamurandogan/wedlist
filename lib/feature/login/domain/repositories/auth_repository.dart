import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signInWithApple();
  Future<Either<Failure, User>> signInWithGoogle();
  Future<void> signOut();
  Future<User?> getCurrentUser();
}
