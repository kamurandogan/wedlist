import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

    test('should return User when Apple sign in is successful', () async {
      // Arrange
      when(() => mockAuthRepository.signInWithApple())
          .thenAnswer((_) async => tUser);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(tUser));
      verify(() => mockAuthRepository.signInWithApple()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return null when Apple sign in is cancelled', () async {
      // Arrange
      when(() => mockAuthRepository.signInWithApple())
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isNull);
      verify(() => mockAuthRepository.signInWithApple()).called(1);
    });

    test('should throw exception when Apple sign in fails', () async {
      // Arrange
      when(() => mockAuthRepository.signInWithApple())
          .thenThrow(Exception('Apple sign in failed'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockAuthRepository.signInWithApple()).called(1);
    });

    test('should handle network errors during Apple sign in', () async {
      // Arrange
      when(() => mockAuthRepository.signInWithApple())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Network error'),
          ),
        ),
      );
    });

    test('should handle Sign in with Apple not available', () async {
      // Arrange
      when(() => mockAuthRepository.signInWithApple())
          .thenThrow(Exception('Sign in with Apple not available'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Sign in with Apple'),
          ),
        ),
      );
    });

    test('should handle authorization error', () async {
      // Arrange
      when(() => mockAuthRepository.signInWithApple())
          .thenThrow(Exception('Authorization failed'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Authorization'),
          ),
        ),
      );
    });
  });
}
