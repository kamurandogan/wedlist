import 'package:wedlist/feature/login/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> signInWithApple();
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Future<User?> getCurrentUser();
}
