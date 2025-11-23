import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/observers/app_bloc_observer.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/services/ads_service.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/login/presentation/blocs/auth_bloc.dart';
import 'package:wedlist/feature/main_page/presentation/blocs/cubit/navigation_cubit.dart';
import 'package:wedlist/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:wedlist/feature/settings/presentation/bloc/theme_cubit.dart';
import 'package:wedlist/feature/settings/presentation/bloc/theme_state.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/firebase_options.dart';
import 'package:wedlist/generated/l10n/app_localizations.dart';
import 'package:wedlist/injection_container.dart';

// Firebase Analytics instance
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Crashlytics
  if (!kDebugMode) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Firestore offline persistence ve cache boyutu ayarı (gerekirse artırılabilir)
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
  } on Exception catch (e) {
    AppLogger.warning('Failed to set Firestore settings', e);
  }
  // Global Bloc gözlemcisi (debug transition & error log)
  Bloc.observer = AppBlocObserver();
  await init(); // Service locator'ı başlat
  // Reklamları başlat (bloklamayan ön ısınma)
  try {
    await sl<AdsService>().init();
  } on Exception catch (e, stackTrace) {
    AppLogger.warning('Ads initialization failed', e, stackTrace);
  }
  // Kullanıcı giriş yaptıysa, wishlist başlangıç verilerini hazırla
  try {
    await Future.wait([
      sl<UserService>().migrateLegacyStringListsIfNeeded(),
      sl<UserService>().ensureWishListInitialized(),
      sl<UserService>().mergeWishListWithCollaborators(),
      sl<UserService>().ensureSymmetricCollaborators(),
      sl<UserService>().ensureProfileInfo(),
      sl<UserService>().cleanUpAsymmetricCollaborators(),
      sl<UserService>().ensureUserItemsSymmetric(),
    ]);
  } on Exception catch (e, stackTrace) {
    AppLogger.error('User service initialization failed', e, stackTrace);
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ThemeCubit>()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => SelectCategoryCubit()),
        BlocProvider(create: (context) => sl<CategorylistBloc>()),
        BlocProvider(
          create: (context) => sl<DowryListBloc>()..add(const DowryListEvent.subscribeDowryItems()),
        ),
        BlocProvider(
          create: (context) => sl<AuthBloc>(),
        ), // Added AuthBloc for login feature
        // Global notifications stream so bottom bar can show unread count badge
        BlocProvider(
          create: (context) =>
              sl<NotificationBloc>()..add(SubscribeNotifications()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'WedList',
          theme: state.themeData,
          routerConfig: appRouter,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('tr'),
            Locale('zh'),
            Locale('de'),
            Locale('es'),
            Locale('fr'),
            Locale('hi'),
            Locale('it'),
            Locale('ja'),
            Locale('nl'),
            Locale('pt'),
          ],
          // (İsteğe bağlı) cihaz dilini desteklemiyorsak fallback
          localeResolutionCallback: (locale, supported) {
            if (locale == null) return const Locale('en');
            for (final l in supported) {
              if (l.languageCode == locale.languageCode) return l;
            }
            return const Locale('en');
          },
        );
      },
    );
  }
}
