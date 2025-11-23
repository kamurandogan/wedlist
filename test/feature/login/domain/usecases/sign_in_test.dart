import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart';
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
    const tFailure = AuthFailure('Giriş başarısız.');

    test('should return User when sign in is successful', () async {
      // Arrange
      when(
        () => mockAuthRepository.signIn(tEmail, tPassword),
      ).thenAnswer((_) async => Right<Failure, User>(tUser));

      // Act
      final result = await useCase(tEmail, tPassword);

      // Assert
      expect(result, Right<Failure, User>(tUser));
      verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when sign in fails', () async {
      // Arrange
      when(
        () => mockAuthRepository.signIn(tEmail, tPassword),
      ).thenAnswer((_) async => const Left<Failure, User>(tFailure));

      // Act
      final result = await useCase(tEmail, tPassword);

      // Assert
      expect(result, const Left<Failure, User>(tFailure));
      verify(() => mockAuthRepository.signIn(tEmail, tPassword)).called(1);
    });
  });
}
