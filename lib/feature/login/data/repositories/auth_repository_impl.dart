import 'package:wedlist/feature/login/data/datasources/auth_remote_data_source.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remoteDataSource);
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<User?> signIn(String email, String password) {
    return remoteDataSource.signIn(email, password);
  }

  @override
  Future<User?> signInWithApple() {
    return remoteDataSource.signInWithApple();
  }

  @override
  Future<User?> signInWithGoogle() {
    return remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }

  @override
  Future<User?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }
}
