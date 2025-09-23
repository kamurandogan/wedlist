import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';

class SignIn {
  SignIn(this.repository);
  final AuthRepository repository;

  Future<User?> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
