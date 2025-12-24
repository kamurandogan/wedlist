import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart' as f;
import 'package:wedlist/core/services/offline_data_migration_service.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/core/services/wishlist_data_migration_service.dart';
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

class MockUserModeService extends Mock implements UserModeService {}

class MockOfflineDataMigrationService extends Mock
    implements OfflineDataMigrationService {}

class MockWishlistDataMigrationService extends Mock
    implements WishlistDataMigrationService {}

void main() {
  late AuthBloc authBloc;
  late MockSignIn mockSignIn;
  late MockSignInWithApple mockSignInWithApple;
  late MockSignInWithGoogle mockSignInWithGoogle;
  late MockCountryPersistenceService mockCountryService;
  late MockUserModeService mockUserModeService;
  late MockOfflineDataMigrationService mockMigrationService;
  late MockWishlistDataMigrationService mockWishlistMigrationService;

  setUp(() {
    mockSignIn = MockSignIn();
    mockSignInWithApple = MockSignInWithApple();
    mockSignInWithGoogle = MockSignInWithGoogle();
    mockCountryService = MockCountryPersistenceService();
    mockUserModeService = MockUserModeService();
    mockMigrationService = MockOfflineDataMigrationService();
    mockWishlistMigrationService = MockWishlistDataMigrationService();

    // Default: user is not in offline mode (authenticated)
    when(
      () => mockUserModeService.isOfflineMode(),
    ).thenAnswer((_) async => false);
    when(
      () => mockUserModeService.setAuthenticatedMode(any()),
    ).thenAnswer((_) async => {});

    authBloc = AuthBloc(
      mockSignIn,
      mockCountryService,
      mockSignInWithApple,
      mockSignInWithGoogle,
      mockUserModeService,
      mockMigrationService,
      mockWishlistMigrationService,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = User(id: 'user123', email: tEmail);
    const tFailure = f.AuthFailure('Giriş başarısız.');

    test('initial state should be AuthInitial', () {
      expect(authBloc.state, const AuthState.initial());
    });

    group('SignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when sign in is successful',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenAnswer((_) async => Right(tUser));
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) =>
            bloc.add(const AuthEvent.signInRequested(tEmail, tPassword)),
        expect: () => [
          const AuthState.loading(),
          AuthState.success(tUser),
        ],
        verify: (_) {
          verify(() => mockSignIn(tEmail, tPassword)).called(1);
          verify(() => mockCountryService.syncSelectedCountryIfAny()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when sign in fails',
        build: () {
          when(
            () => mockSignIn(tEmail, tPassword),
          ).thenAnswer((_) async => const Left(tFailure));
          return authBloc;
        },
        act: (bloc) =>
            bloc.add(const AuthEvent.signInRequested(tEmail, tPassword)),
        expect: () => [
          const AuthState.loading(),
          const AuthState.failure('Giriş başarısız.'),
        ],
        verify: (_) {
          verify(() => mockSignIn(tEmail, tPassword)).called(1);
          verifyNever(() => mockCountryService.syncSelectedCountryIfAny());
        },
      );
    });

    group('SignInWithGoogleRequested', () {
      final tGoogleUser = User(id: 'google123', email: 'test@gmail.com');

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when Google sign in is successful',
        build: () {
          when(
            () => mockSignInWithGoogle(),
          ).thenAnswer((_) async => Right(tGoogleUser));
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.signInWithGoogleRequested()),
        expect: () => [
          const AuthState.loading(),
          AuthState.success(tGoogleUser),
        ],
        verify: (_) {
          verify(() => mockSignInWithGoogle()).called(1);
          verify(() => mockCountryService.syncSelectedCountryIfAny()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when Google sign in fails',
        build: () {
          when(
            () => mockSignInWithGoogle(),
          ).thenAnswer(
            (_) async =>
                const Left(f.AuthFailure('Google ile giriş başarısız.')),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.signInWithGoogleRequested()),
        expect: () => [
          const AuthState.loading(),
          const AuthState.failure('Google ile giriş başarısız.'),
        ],
      );
    });

    group('SignInWithAppleRequested', () {
      final tAppleUser = User(id: 'apple123', email: 'test@icloud.com');

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when Apple sign in is successful',
        build: () {
          when(
            () => mockSignInWithApple(),
          ).thenAnswer((_) async => Right(tAppleUser));
          when(
            () => mockCountryService.syncSelectedCountryIfAny(),
          ).thenAnswer((_) async => {});
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.signInWithAppleRequested()),
        expect: () => [
          const AuthState.loading(),
          AuthState.success(tAppleUser),
        ],
        verify: (_) {
          verify(() => mockSignInWithApple()).called(1);
          verify(() => mockCountryService.syncSelectedCountryIfAny()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when Apple sign in fails',
        build: () {
          when(
            () => mockSignInWithApple(),
          ).thenAnswer(
            (_) async =>
                const Left(f.AuthFailure('Apple ile giriş başarısız.')),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.signInWithAppleRequested()),
        expect: () => [
          const AuthState.loading(),
          const AuthState.failure('Apple ile giriş başarısız.'),
        ],
      );
    });
  });
}
