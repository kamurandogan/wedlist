part of '../../splash_page.dart';

mixin SplashPageMixin on State<SplashPage> {
  Future<void> _goNextPage() async {
    final router = GoRouter.of(context);
    await Future<void>.delayed(const Duration(seconds: 2));
    // Onboarding kontrolü: ilk girişte onboarding'i göster, sonrakilerde atla
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    if (!seen) {
      if (!mounted) return;
      router.go(AppRoute.onBoarding.path);
      return;
    }
    final authRepository = sl<AuthRepository>();
    final user = await authRepository.getCurrentUser();
    if (!mounted) return;
    if (user != null) {
      // E-posta doğrulama durumunu güncellemek için oturumu tazele
      final firebaseAuth = FirebaseAuth.instance;
      try {
        await firebaseAuth.currentUser?.reload();
      } on Exception {
        // sessiz geç
      }
      // Eğer kullanıcı giriş yapmış fakat e-postası doğrulanmamışsa doğrulama sayfasına yönlendir
      final isVerified = firebaseAuth.currentUser?.emailVerified ?? false;
      if (!isVerified) {
        if (!mounted) return;
        router.go(AppRoute.verification.path);
      } else {
        // Kullanıcı verilerini Splash ekranında önceden çek
        try {
          if (!mounted) return;
          await sl<UserService>().ensureWishListInitialized();
          if (!mounted) return;
          // Partner item sahiplik simetrisi (dowry list) kabul sonrası eksik kalmışsa heal et
          try {
            await sl<UserService>().ensureUserItemsSymmetric();
          } on Exception catch (_) {}
          if (!mounted) return;

          // DowryList verilerini bekle: Loaded/Empty/Error durumlarından biri gelene kadar (maks 4 sn)
          final dowryBloc = context.read<DowryListBloc>()
          ..add(FetchDowryListItems());
          // Var olan bir fetch yoksa tetikle
          try {
            await dowryBloc.stream
                .firstWhere((s) => s is DowryListLoaded || s is DowryListEmpty || s is DowryListError)
                .timeout(const Duration(seconds: 4));
          } on Exception {
            // zaman aşımı/akış hatası: sessiz geç ve devam et
          }
        } on Exception {
          // init/preload hataları: sessiz geç
        }
        if (!mounted) return;
        router.go(AppRoute.main.path);
      }
    } else {
      if (!mounted) return;
      router.go(AppRoute.login.path);
    }
  }

  @override
  void initState() {
    _goNextPage();
    super.initState();
  }
}
