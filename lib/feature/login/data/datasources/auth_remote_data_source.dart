import 'package:wedlist/feature/login/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> signIn(String email, String password);
  Future<UserModel?> signInWithApple();
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}
