import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/feature/login/data/datasources/auth_remote_data_source.dart';
import 'package:wedlist/feature/login/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message: 'E-posta adresiniz doğrulanmamış. Lütfen e-postanızı kontrol edin.',
          );
        }
        return UserModel(id: user.uid, email: user.email ?? '');
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Şifre yanlış.');
      } else if (e.code == 'email-not-verified') {
        throw Exception('E-posta adresiniz doğrulanmamış. Lütfen e-postanızı kontrol edin.');
      } else {
        throw Exception('Giriş sırasında bir hata oluştu: ${e.message}');
      }
    } catch (e) {
      throw Exception('Giriş sırasında bir hata oluştu: $e');
    }
  }

  @override
  Future<void> signOut() async {
    // TODO(kamuran): Implement sign out logic
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return UserModel(id: user.uid, email: user.email ?? '');
    }
    return null;
  }
}
