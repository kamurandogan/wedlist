import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/feature/register/domain/entities/register_entity.dart';
import 'package:wedlist/feature/register/domain/repositories/register_repository.dart';
import 'package:wedlist/feature/register/domain/usecases/register_usecase.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  late RegisterUseCase useCase;
  late MockRegisterRepository mockRepository;

  setUp(() {
    mockRepository = MockRegisterRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      RegisterEntity(
        name: 'test',
        email: 'test@example.com',
        password: 'password',
      ),
    );
  });

  group('RegisterUseCase', () {
    final tEntity = RegisterEntity(
      name: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
      weddingDate: DateTime(2025, 12, 31),
    );

    test('should call repository.register with entity', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase(tEntity);

      // Assert
      verify(() => mockRepository.register(tEntity)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should complete successfully when registration succeeds', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => {});

      // Act & Assert
      await expectLater(
        useCase(tEntity),
        completes,
      );
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenThrow(Exception('Registration failed'));

      // Act & Assert
      expect(
        () => useCase(tEntity),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.register(tEntity)).called(1);
    });

    test('should handle network errors', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase(tEntity),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Network error'),
          ),
        ),
      );
    });

    test('should handle email already exists error', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenThrow(Exception('Email already in use'));

      // Act & Assert
      expect(
        () => useCase(tEntity),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Email already in use'),
          ),
        ),
      );
    });

    test('should handle weak password error', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenThrow(Exception('Password is too weak'));

      // Act & Assert
      expect(
        () => useCase(tEntity),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Password is too weak'),
          ),
        ),
      );
    });

    test('should handle registration with optional wedding date', () async {
      // Arrange
      final entityWithoutDate = RegisterEntity(
        name: 'Jane Doe',
        email: 'jane@example.com',
        password: 'password456',
      );
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase(entityWithoutDate);

      // Assert
      verify(() => mockRepository.register(entityWithoutDate)).called(1);
    });

    test('should handle registration with avatar bytes', () async {
      // Arrange
      final entityWithAvatar = RegisterEntity(
        name: 'Bob Smith',
        email: 'bob@example.com',
        password: 'password789',
        avatarBytes: Uint8List.fromList([1, 2, 3, 4, 5]),
      );
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase(entityWithAvatar);

      // Assert
      verify(() => mockRepository.register(entityWithAvatar)).called(1);
    });
  });
}
