import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_google.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInWithGoogle useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInWithGoogle(mockAuthRepository);
  });

  group('SignInWithGoogle UseCase', () {
    final tUser = User(id: 'google_user123', email: 'test@gmail.com');
    const tFailure = AuthFailure('Google ile giriş başarısız.');

    test('should return User when Google sign in is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => Right<Failure, User>(tUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right<Failure, User>(tUser));
      verify(() => mockAuthRepository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when Google sign in fails', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => const Left<Failure, User>(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left<Failure, User>(tFailure));
      verify(() => mockAuthRepository.signInWithGoogle()).called(1);
    });
  });
}
