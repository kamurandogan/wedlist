import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_apple.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInWithApple useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInWithApple(mockAuthRepository);
  });

  group('SignInWithApple UseCase', () {
    final tUser = User(id: 'apple_user123', email: 'test@icloud.com');
    const tFailure = AuthFailure('Apple ile giriş başarısız.');

    test('should return User when Apple sign in is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithApple(),
      ).thenAnswer((_) async => Right<Failure, User>(tUser));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right<Failure, User>(tUser));
      verify(() => mockAuthRepository.signInWithApple()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when Apple sign in fails', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithApple(),
      ).thenAnswer((_) async => const Left<Failure, User>(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left<Failure, User>(tFailure));
      verify(() => mockAuthRepository.signInWithApple()).called(1);
    });
  });
}
