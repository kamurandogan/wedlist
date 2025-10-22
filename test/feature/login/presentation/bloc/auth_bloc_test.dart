import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/user/country_persistence.dart';
import 'package:wedlist/feature/login/domain/entities/user.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_apple.dart';
import 'package:wedlist/feature/login/domain/usecases/sign_in_with_google.dart';
import 'package:wedlist/feature/login/presentation/blocs/auth_bloc.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignInWithApple extends Mock implements SignInWithApple {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockCountryPersistenceService extends Mock
    implements CountryPersistenceService {}

void main() {
  late AuthBloc authBloc;
  late MockSignIn mockSignIn;
  late MockSignInWithApple mockSignInWithApple;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockCountryPersistenceService mockCountryService;

  setUp(() {
    mockSignIn = MockSignIn();
    mockSignInWithApple = MockSignInWithApple();
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockCountryService = MockCountryPersistenceService();

    authBloc = AuthBloc(
      mockSignIn,
      mockCountryService,
      mockSignInWithApple,
      mockSignInWithGoogle,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = User(id: 'user123', email: tEmail);

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('SignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when sign in is successful',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenAnswer((_) async => tUser);
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInRequested(tEmail, tPassword)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>().having((s) => s.user, 'user', tUser),
        ],
        verify: (_) {
          verify(() => mockSignIn(tEmail, tPassword)).called(1);
          verify(() => mockCountryService.syncSelectedCountryIfAny()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when sign in returns null',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInRequested(tEmail, tPassword)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Giriş başarısız.',
          ),
        ],
        verify: (_) {
          verify(() => mockSignIn(tEmail, tPassword)).called(1);
          verifyNever(() => mockCountryService.syncSelectedCountryIfAny());
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when exception occurs',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenThrow(Exception('Network error'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInRequested(tEmail, tPassword)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Network error',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] with cleaned error message',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenThrow(Exception('Invalid credentials'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInRequested(tEmail, tPassword)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Invalid credentials',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when country sync fails but sign in succeeds',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenAnswer((_) async => tUser);
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenThrow(Exception('Country sync failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInRequested(tEmail, tPassword)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Country sync failed',
          ),
        ],
      );
    });

    group('SignInWithGoogleRequested', () {
      final tGoogleUser = User(id: 'google123', email: 'test@gmail.com');

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when Google sign in is successful',
        build: () {
          when(
            () => mockSignInWithGoogle(),
          ).thenAnswer((_) async => tGoogleUser);
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithGoogleRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>().having((s) => s.user, 'user', tGoogleUser),
        ],
        verify: (_) {
          verify(() => mockSignInWithGoogle()).called(1);
          verify(() => mockCountryService.syncSelectedCountryIfAny()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when Google sign in returns null',
        build: () {
          when(() => mockSignInWithGoogle()).thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithGoogleRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Giriş başarısız.',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when Google sign in throws exception',
        build: () {
          when(
            () => mockSignInWithGoogle(),
          ).thenThrow(Exception('Google sign in cancelled'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithGoogleRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Google sign in cancelled',
          ),
        ],
      );
    });

    group('SignInWithAppleRequested', () {
      final tAppleUser = User(id: 'apple123', email: 'test@icloud.com');

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when Apple sign in is successful',
        build: () {
          when(() => mockSignInWithApple()).thenAnswer((_) async => tAppleUser);
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithAppleRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthSuccess>().having((s) => s.user, 'user', tAppleUser),
        ],
        verify: (_) {
          verify(() => mockSignInWithApple()).called(1);
          verify(() => mockCountryService.syncSelectedCountryIfAny()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when Apple sign in returns null',
        build: () {
          when(() => mockSignInWithApple()).thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithAppleRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Giriş başarısız.',
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when Apple sign in throws exception',
        build: () {
          when(
            () => mockSignInWithApple(),
          ).thenThrow(Exception('Apple sign in failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithAppleRequested()),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            'Apple sign in failed',
          ),
        ],
      );
    });

    group('Edge Cases', () {
      blocTest<AuthBloc, AuthState>(
        'handles multiple rapid sign in requests correctly',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenAnswer((_) async => tUser);
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc
          ..add(SignInRequested(tEmail, tPassword))
          ..add(SignInRequested(tEmail, tPassword)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthLoading>(),
          isA<AuthSuccess>(),
          isA<AuthSuccess>(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'handles empty email gracefully',
        build: () {
          when(
            () => mockSignIn('', tPassword),
          ).thenThrow(Exception('Email cannot be empty'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInRequested('', tPassword)),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthFailure>().having(
            (s) => s.message,
            'message',
            contains('Email'),
          ),
        ],
      );
    });
  });
}
