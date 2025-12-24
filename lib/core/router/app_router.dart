import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/services/navigation_service.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/feature/chart/presentation/ui/pages/chart_page.dart';
import 'package:wedlist/feature/item_add/add_item_screen.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_item_bloc.dart';
import 'package:wedlist/feature/login/login_page.dart';
import 'package:wedlist/feature/main_page/main_page.dart';
import 'package:wedlist/feature/on_boarding/on_boarding_page.dart';
import 'package:wedlist/feature/register/presentation/blocs/register_bloc.dart';
import 'package:wedlist/feature/register/presentation/ui/pages/register_page.dart';
import 'package:wedlist/feature/settings/presentation/ui/pages/collaborators_page.dart';
import 'package:wedlist/feature/settings/presentation/ui/pages/delete_account_page.dart';
import 'package:wedlist/feature/settings/settings_page.dart';
import 'package:wedlist/feature/splash/splash_page.dart';
import 'package:wedlist/feature/verification/verification_page.dart';
import 'package:wedlist/generated/l10n/app_localizations.dart';
import 'package:wedlist/injection_container.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),
  observers: [
    FirebaseAnalyticsObserver(analytics: _analytics),
  ],
  redirect: (context, state) async {
    final userModeService = sl<UserModeService>();
    final isOfflineMode = await userModeService.isOfflineMode();
    final user = _auth.currentUser;
    final loggedIn = user != null;
    final isVerified = user?.emailVerified ?? false;
    final loc = state.uri.path;

    // Splash rotasında yönlendirmeyi SplashPageMixin'e bırak
    if (loc == '/') {
      return null;
    }

    final isAuthRoute =
        loc == AppRoute.login.path ||
        loc == AppRoute.register.path ||
        loc == AppRoute.onBoarding.path;

    // Eğer kullanıcı giriş yaptı ama e-postası doğrulanmadıysa, doğrulama sayfasına yönlendir
    if (loggedIn && !isVerified && loc != AppRoute.verification.path) {
      return AppRoute.verification.path;
    }

    // Eğer kullanıcı giriş yaptı ve doğrulandıysa, auth rotalarına veya verification sayfasına gitmesin
    if (loggedIn &&
        isVerified &&
        (isAuthRoute || loc == AppRoute.verification.path)) {
      return AppRoute.main.path;
    }

    // Çevrimdışı kullanıcılar ana uygulamaya erişebilir
    if (isOfflineMode && !loggedIn) {
      // İşbirliği rotalarını engelle
      if (loc == AppRoute.collaborators.path) {
        return AppRoute.main.path; // Ana ekrana yönlendir
      }
      return null; // Diğer rotalara erişime izin ver
    }

    // Mod ayarlanmamış ve giriş yapılmamışsa
    if (!loggedIn &&
        !isOfflineMode &&
        !isAuthRoute &&
        loc != AppRoute.onBoarding.path) {
      return AppRoute.login.path;
    }

    return null; // Değişiklik yok
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoute.main.path,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: AppRoute.onBoarding.path,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoute.login.path,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoute.register.path,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<RegisterBloc>(),
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: AppRoute.verification.path,
      builder: (context, state) => const VerificationPage(),
    ),
    GoRoute(
      path: AppRoute.addItem.path,
      builder: (context, state) {
        // Query parametrelerinden ItemEntity'yi oluştur
        final id = state.uri.queryParameters['id'];
        final title = state.uri.queryParameters['title'];
        final category = state.uri.queryParameters['category'];

        if (id == null || title == null || category == null) {
          // Hata ekranı, fallback veya yönlendirme
          return Scaffold(
            body: Center(
              child: Text(
                '${AppLocalizations.of(context).errorPrefix} Ürün bilgisi bulunamadı',
              ),
            ),
          );
        }

        // ItemEntity'yi query parametrelerinden oluştur
        final item = ItemEntity(
          id: id,
          title: title,
          category: category,
        );

        return BlocProvider(
          create: (context) => sl<AddItemBloc>(),
          child: AddItemScreen(
            item: item,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoute.settings.path,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoute.deleteAccount.path,
      builder: (context, state) => const DeleteAccountPage(),
    ),
    GoRoute(
      path: AppRoute.collaborators.path,
      builder: (context, state) => const CollaboratorsPage(),
    ),
    GoRoute(
      path: AppRoute.chart.path,
      builder: (context, state) => const ChartPage(),
    ),

    // Diğer rotaları buraya ekle
  ],
);

enum AppRoute {
  main('/main'),
  onBoarding('/onboarding'),
  home('/home'),
  login('/login'),
  verification('/verification'),
  addItem('/add-item'),
  settings('/settings'),
  collaborators('/collaborators'),
  deleteAccount('/account/delete'),
  chart('/chart'),
  register('/register');

  const AppRoute(this.path);
  final String path;
}
