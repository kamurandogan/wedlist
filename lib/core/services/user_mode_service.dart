import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Kullanıcı modunu yöneten servis
/// Offline (çevrimdışı) ve Authenticated (kimlik doğrulamalı) modlar arasında geçiş yapar
enum UserMode {
  /// Çevrimdışı mod - yerel UUID ile çalışır, Firebase senkronizasyonu yok
  offline,

  /// Kimlik doğrulamalı mod - Firebase UID ile çalışır, tam senkronizasyon aktif
  authenticated,
}

/// UserMode için extension metotları
extension UserModeExtension on UserMode {
  String get value {
    switch (this) {
      case UserMode.offline:
        return 'offline';
      case UserMode.authenticated:
        return 'authenticated';
    }
  }

  static UserMode fromString(String value) {
    switch (value) {
      case 'offline':
        return UserMode.offline;
      case 'authenticated':
        return UserMode.authenticated;
      default:
        return UserMode.offline;
    }
  }
}

/// Kullanıcı modu yönetim servisi
///
/// Bu servis şunlardan sorumludur:
/// - Kullanıcı modunu takip etme (offline/authenticated)
/// - Offline kullanıcılar için yerel UUID oluşturma ve saklama
/// - Mod geçişlerini yönetme
/// - SharedPreferences'ta mod durumunu kalıcı hale getirme
class UserModeService {
  UserModeService(this._prefs);

  final SharedPreferences _prefs;
  final _uuid = const Uuid();

  // SharedPreferences anahtarları
  static const String _userModeKey = 'user_mode';
  static const String _localUserIdKey = 'local_user_id';
  static const String _firebaseUserIdKey = 'firebase_user_id';

  // Stream controller for mode changes
  final _modeController = StreamController<UserMode>.broadcast();

  /// Mevcut kullanıcı modunu döndürür
  Future<UserMode> getCurrentMode() async {
    final modeString = _prefs.getString(_userModeKey);
    if (modeString == null) {
      // Varsayılan olarak offline mod (ilk kurulumda)
      return UserMode.offline;
    }
    return UserModeExtension.fromString(modeString);
  }

  /// Kullanıcı ID'sini döndürür
  /// - Offline modda: Yerel UUID
  /// - Authenticated modda: Firebase UID
  Future<String> getUserId() async {
    final mode = await getCurrentMode();
    if (mode == UserMode.offline) {
      return getLocalUserId();
    } else {
      return getFirebaseUserId();
    }
  }

  /// Offline mod için yerel UUID döndürür
  /// Eğer yoksa yeni bir UUID oluşturur ve saklar
  Future<String> getLocalUserId() async {
    var localId = _prefs.getString(_localUserIdKey);
    if (localId == null || localId.isEmpty) {
      // Yeni UUID oluştur ve sakla
      localId = _uuid.v4();
      await _prefs.setString(_localUserIdKey, localId);
    }
    return localId;
  }

  /// Firebase UID'yi döndürür (authenticated modda)
  Future<String> getFirebaseUserId() async {
    final firebaseId = _prefs.getString(_firebaseUserIdKey);
    return firebaseId ?? '';
  }

  /// Offline moda geçiş yapar
  Future<void> setOfflineMode() async {
    await _prefs.setString(_userModeKey, UserMode.offline.value);
    // Yerel UUID'nin var olduğundan emin ol
    await getLocalUserId();
    _modeController.add(UserMode.offline);
  }

  /// Authenticated moda geçiş yapar ve Firebase UID'yi saklar
  Future<void> setAuthenticatedMode(String firebaseUid) async {
    await _prefs.setString(_userModeKey, UserMode.authenticated.value);
    await _prefs.setString(_firebaseUserIdKey, firebaseUid);
    _modeController.add(UserMode.authenticated);
  }

  /// Offline modda olup olmadığını kontrol eder (async)
  Future<bool> isOfflineMode() async {
    final mode = await getCurrentMode();
    return mode == UserMode.offline;
  }

  /// Offline modda olup olmadığını kontrol eder (senkron - UI için)
  /// SharedPreferences zaten memory'de cache'li olduğu için güvenle kullanılabilir
  bool isOfflineModeSync() {
    final modeString = _prefs.getString(_userModeKey);
    if (modeString == null) {
      return true; // Varsayılan offline mod
    }
    return UserModeExtension.fromString(modeString) == UserMode.offline;
  }

  /// Authenticated modda olup olmadığını kontrol eder
  Future<bool> isAuthenticatedMode() async {
    final mode = await getCurrentMode();
    return mode == UserMode.authenticated;
  }

  /// Kullanıcı modu değişikliklerini dinlemek için stream
  Stream<UserMode> watchUserMode() {
    return _modeController.stream;
  }

  /// Offline verilerini temizler (migrasyon sonrası)
  Future<void> clearOfflineData() async {
    await _prefs.remove(_localUserIdKey);
  }

  /// Tüm kullanıcı modu verilerini temizler (logout sonrası)
  Future<void> clearAllModeData() async {
    await _prefs.remove(_userModeKey);
    await _prefs.remove(_localUserIdKey);
    await _prefs.remove(_firebaseUserIdKey);
  }

  /// Logout sonrası offline moda döner ama verileri korur
  Future<void> returnToOfflineModeAfterLogout() async {
    await _prefs.remove(_firebaseUserIdKey);
    await setOfflineMode();
  }

  /// Dispose
  void dispose() {
    _modeController.close();
  }
}
