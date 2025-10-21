import 'package:flutter/material.dart';

/// Standard padding values used throughout the app.
///
/// Provides consistent spacing for better UI/UX.
class AppPadding {
  AppPadding._();

  static const double tiny = 4;
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Common padding combinations
  static const EdgeInsets horizontal = EdgeInsets.symmetric(horizontal: 30);
  static const EdgeInsets vertical = EdgeInsets.symmetric(vertical: 14);
  static const EdgeInsets all = EdgeInsets.all(medium);
  static const EdgeInsets allSmall = EdgeInsets.all(small);
  static const EdgeInsets allLarge = EdgeInsets.all(large);
}

/// Standard border radius values
class AppBorderRadius {
  AppBorderRadius._();

  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xl = 24;

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
}

/// Standard button sizes
class AppButtonSizes {
  AppButtonSizes._();

  static const Size small = Size(120, 40);
  static const Size medium = Size(170, 50);
  static const Size large = Size(220, 56);
  static const Size full = Size(double.infinity, 50);
}

/// Standard icon sizes
class AppIconSizes {
  AppIconSizes._();

  static const double small = 16;
  static const double medium = 24;
  static const double large = 32;
  static const double xl = 48;
}

/// Standard animation durations
class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

/// Breakpoints for responsive design
class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;
}
