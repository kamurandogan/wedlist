part of '../../on_boarding_page.dart';

mixin OnboardingMixin<T extends StatefulWidget> on State<T> {
  List<OnboardingEntity> get onboardingData => [
    OnboardingEntity(
      title: context.loc.onboardingTitle1,
      body: context.loc.onboardingBody1,
      imagePath: 'assets/images/planning.png',
    ),
    OnboardingEntity(
      title: context.loc.onboardingTitle2,
      body: context.loc.onboardingBody2,
      imagePath: 'assets/images/takip.png',
    ),
    OnboardingEntity(
      title: context.loc.onboardingTitle3,
      body: context.loc.onboardingBody3,
      imagePath: 'assets/images/harcama.png',
    ),
  ];

  static final PageController onboardingController = PageController();

  // pageview bg color
  Color pageViewBackgroundColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFF6C634);
      case 1:
        return const Color(0xFF88D8DF);
      case 2:
        return const Color(0xFFF2D1DC);
      default:
        return AppColors.bg;
    }
  }

  // Country selection state for onboarding
  static const List<String> _supportedCountries = [
    'TR',
    'US',
    'CA',
    'UK',
    'AU',
    'DE',
    'FR',
    'IT',
    'JP',
  ];
  static const Map<String, String> _countryLabels = {
    'TR': 'Turkey',
    'US': 'United States',
    'CA': 'Canada',
    'UK': 'United Kingdom',
    'AU': 'Australia',
    'DE': 'Germany',
    'FR': 'France',
    'IT': 'Italy',
    'JP': 'Japan',
  };
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Prefill from device locale region if available, else from language, else US
    final loc = ui.PlatformDispatcher.instance.locale;
    final region = (loc.countryCode ?? '').toUpperCase();
    String guess;
    if (_supportedCountries.contains(region)) {
      guess = region;
    } else {
      switch (loc.languageCode) {
        case 'tr':
          guess = 'TR';
        case 'de':
          guess = 'DE';
        case 'fr':
          guess = 'FR';
        case 'it':
          guess = 'IT';
        case 'ja':
          guess = 'JP';
        case 'en':
        default:
          guess = 'US';
      }
    }
    _selectedCountry = guess;
  }
}
