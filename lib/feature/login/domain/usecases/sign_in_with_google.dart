import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  const SignInWithGoogle(this.repository);
  final AuthRepository repository;

  Future<User?> call() => repository.signInWithGoogle();
}
