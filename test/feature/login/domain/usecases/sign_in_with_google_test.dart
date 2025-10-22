import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

    test('should return User when Google sign in is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => tUser);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(tUser));
      verify(() => mockAuthRepository.signInWithGoogle()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return null when Google sign in is cancelled', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isNull);
      verify(() => mockAuthRepository.signInWithGoogle()).called(1);
    });

    test('should throw exception when Google sign in fails', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenThrow(Exception('Google sign in failed'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockAuthRepository.signInWithGoogle()).called(1);
    });

    test('should handle network errors during Google sign in', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenThrow(Exception('Network error'));

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

    test('should handle Google Play Services not available', () async {
      // Arrange
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenThrow(Exception('Google Play Services not available'));

      // Act & Assert
      expect(
        () => useCase(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Google Play Services'),
          ),
        ),
      );
    });
  });
}
