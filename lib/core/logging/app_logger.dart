import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Central logging service for the application.
///
/// Provides different log levels and integrates with Firebase Crashlytics
/// for production error tracking.
///
/// Usage:
/// ```dart
/// AppLogger.debug('User logged in: $userId');
/// AppLogger.info('Payment successful');
/// AppLogger.warning('API rate limit approaching');
/// AppLogger.error('Failed to load data', error, stackTrace);
/// ```
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
    ),
    level: kDebugMode ? Level.debug : Level.warning,
  );

  /// Log debug messages (development only)
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log informational messages
  static void info(String message) {
    _logger.i(message);
  }

  /// Log warning messages
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error messages and send to Crashlytics in production
  static void error(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.e(message, error: error, stackTrace: stackTrace);

    // Send to Firebase Crashlytics in production
    if (!kDebugMode && error != null) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: message,
      );
    }
  }

  /// Log BLoC transitions (development only)
  static void blocTransition(String blocName, String event, String state) {
    if (kDebugMode) {
      _logger.d('🔄 [$blocName] $event → $state');
    }
  }

  /// Log BLoC errors
  static void blocError(
    String blocName,
    dynamic error,
    StackTrace stackTrace,
  ) {
    _logger.e(
      '❌ [$blocName] Error',
      error: error,
      stackTrace: stackTrace,
    );

    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'BLoC Error in $blocName',
      );
    }
  }

  /// Set user identifier for Crashlytics
  static Future<void> setUserId(String userId) async {
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
  }

  /// Set custom key-value pairs for Crashlytics
  static Future<void> setCustomKey(String key, String value) async {
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    }
  }
}
