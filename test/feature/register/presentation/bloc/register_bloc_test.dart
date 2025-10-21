import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/feature/register/domain/entities/register_entity.dart';
import 'package:wedlist/feature/register/domain/usecases/register_usecase.dart';
import 'package:wedlist/feature/register/presentation/blocs/register_bloc.dart';

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

void main() {
  late RegisterBloc bloc;
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    bloc = RegisterBloc(mockRegisterUseCase);
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

  tearDown(() {
    bloc.close();
  });

  group('RegisterBloc', () {
    final tEntity = RegisterEntity(
      name: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
      weddingDate: DateTime(2025, 12, 31),
    );

    test('initial state should be RegisterInitial', () {
      expect(bloc.state, isA<RegisterInitial>());
    });

    group('RegisterSubmitted', () {
      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterLoading, RegisterSuccess] when registration succeeds',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => {});
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterSuccess>(),
        ],
        verify: (_) {
          verify(() => mockRegisterUseCase(tEntity)).called(1);
        },
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterLoading, RegisterFailure] when exception occurs',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('Registration failed'));
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('Registration failed'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterLoading, RegisterFailure] with email already in use error',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('email-already-in-use'));
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('email-already-in-use'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterLoading, RegisterFailure] with weak password error',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('weak-password'));
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('weak-password'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'emits [RegisterLoading, RegisterFailure] with network error',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('Network error'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles registration without optional wedding date',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => {});
          return bloc;
        },
        act: (bloc) => bloc.add(
          RegisterSubmitted(
            RegisterEntity(
              name: 'Jane Doe',
              email: 'jane@example.com',
              password: 'password456',
            ),
          ),
        ),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterSuccess>(),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles registration with avatar bytes',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => {});
          return bloc;
        },
        act: (bloc) => bloc.add(
          RegisterSubmitted(
            RegisterEntity(
              name: 'Bob Smith',
              email: 'bob@example.com',
              password: 'password789',
              avatarBytes: Uint8List.fromList([1, 2, 3, 4, 5]),
            ),
          ),
        ),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterSuccess>(),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles invalid email format error',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('invalid-email'));
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('invalid-email'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles multiple rapid registration attempts',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => {});
          return bloc;
        },
        act: (bloc) => bloc
          ..add(RegisterSubmitted(tEntity))
          ..add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterSuccess>(),
          isA<RegisterLoading>(),
          isA<RegisterSuccess>(),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles user cancelled operation',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('Operation cancelled'));
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('Operation cancelled'),
          ),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<RegisterBloc, RegisterState>(
        'handles empty name field',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('Name cannot be empty'));
          return bloc;
        },
        act: (bloc) => bloc.add(
          RegisterSubmitted(
            RegisterEntity(
              name: '',
              email: 'test@example.com',
              password: 'password123',
            ),
          ),
        ),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('Name cannot be empty'),
          ),
        ],
      );

      blocTest<RegisterBloc, RegisterState>(
        'handles timeout error',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenThrow(Exception('Request timeout'));
          return bloc;
        },
        act: (bloc) => bloc.add(RegisterSubmitted(tEntity)),
        expect: () => [
          isA<RegisterLoading>(),
          isA<RegisterFailure>().having(
            (s) => s.message,
            'message',
            contains('timeout'),
          ),
        ],
      );
    });
  });
}
