import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';

class SignInWithApple {
  const SignInWithApple(this.repository);
  final AuthRepository repository;

  Future<User?> call() => repository.signInWithApple();
}
