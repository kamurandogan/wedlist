import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/repositories/auth_repository.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignIn useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignIn(mockAuthRepository);
  });

  group('SignIn UseCase', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = User(id: 'user123', email: tEmail);

    test('should return User when sign in is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.signIn(tEmail, tPassword),
      ).thenAnswer((_) async => tUser);

      // Act
      final result = await useCase(tEmail, tPassword);

      // Assert
      expect(result, equals(tUser));
      verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return null when sign in fails', () async {
      // Arrange
      when(
        () => mockAuthRepository.signIn(tEmail, tPassword),
      ).thenAnswer((_) async => null);

      // Act
      final result = await useCase(tEmail, tPassword);

      // Assert
      expect(result, isNull);
      verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      when(
        () => mockAuthRepository.signIn(tEmail, tPassword),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase(tEmail, tPassword),
        throwsA(isA<Exception>()),
      );
      verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
    });

    test('should handle empty email', () async {
      // Arrange
      const emptyEmail = '';
      when(
        () => mockAuthRepository.signIn(emptyEmail, tPassword),
      ).thenThrow(Exception('Email cannot be empty'));

      // Act & Assert
      expect(
        () => useCase(emptyEmail, tPassword),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle empty password', () async {
      // Arrange
      const emptyPassword = '';
      when(
        () => mockAuthRepository.signIn(tEmail, emptyPassword),
      ).thenThrow(Exception('Password cannot be empty'));

      // Act & Assert
      expect(
        () => useCase(tEmail, emptyPassword),
        throwsA(isA<Exception>()),
      );
    });
  });
}
