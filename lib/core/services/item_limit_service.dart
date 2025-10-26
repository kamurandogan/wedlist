import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlist/core/services/purchase_service.dart';

/// Kullanıcının ekleyebileceği item sayısını yöneten servis.
///
/// Free Tier:
/// - İlk 5 item tamamen ücretsiz
/// - 6. item'dan itibaren rewarded ad izleyerek +5 item bonus kazanılır
///
/// Premium Tier (Remove Ads satın alma):
/// - Sınırsız item ekleme
/// - Hiç reklam gösterilmez
///
/// Kullanım:
/// ```dart
/// final limitService = sl<ItemLimitService>();
/// if (await limitService.canAddItem()) {
///   // Item ekle
///   await limitService.onItemAdded();
/// } else {
///   // Limit dialog göster
/// }
/// ```
class ItemLimitService {
  ItemLimitService({
    required PurchaseService purchaseService,
  }) : _purchaseService = purchaseService;

  final PurchaseService _purchaseService;

  // SharedPreferences anahtarları
  static const String _keyItemsAdded = 'item_limit_items_added';
  static const String _keyBonusItems = 'item_limit_bonus_items';
  static const String _keyLastResetDate = 'item_limit_last_reset';

  // Sabitler
  static const int freeItemLimit = 5;
  static const int bonusItemsPerAd = 5;

  SharedPreferences? _prefs;

  /// Servisi başlatır (SharedPreferences yükler)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _checkDailyReset();
  }

  /// Kullanıcı yeni bir item ekleyebilir mi?
  ///
  /// Şu durumlarda true döner:
  /// 1. Remove Ads satın alınmışsa (sınırsız)
  /// 2. Henüz 5 ücretsiz item eklememiş
  /// 3. Bonus item hakkı varsa (rewarded ad izlemiş)
  Future<bool> canAddItem() async {
    await init();

    // Remove Ads satın almışsa sınırsız
    if (_purchaseService.removeAds.value) {
      return true;
    }

    final totalAdded = await getTotalItemsAdded();
    final bonusItems = await _getBonusItems();

    // İlk 5 item ücretsiz
    if (totalAdded < freeItemLimit) {
      return true;
    }

    // Bonus item hakkı varsa
    if (bonusItems > 0) {
      return true;
    }

    // Limit doldu
    return false;
  }

  /// Item başarıyla eklendikten sonra çağrılır
  Future<void> onItemAdded() async {
    await init();

    // Remove Ads varsa sayaç tutmaya gerek yok
    if (_purchaseService.removeAds.value) {
      return;
    }

    final totalAdded = await getTotalItemsAdded();
    final bonusItems = await _getBonusItems();

    // Toplam item sayısını artır
    await _setTotalItemsAdded(totalAdded + 1);

    // Eğer bonus kullanıyorsa, bonus'tan düş
    if (totalAdded >= freeItemLimit && bonusItems > 0) {
      await _setBonusItems(bonusItems - 1);
      if (kDebugMode) {
        debugPrint(
          'ItemLimitService: Bonus item kullanıldı. Kalan: ${bonusItems - 1}',
        );
      }
    }

    if (kDebugMode) {
      debugPrint(
        'ItemLimitService: Item eklendi. Toplam: ${totalAdded + 1}, Bonus: ${bonusItems > 0 ? bonusItems - 1 : 0}',
      );
    }
  }

  /// Rewarded ad izledikten sonra bonus item ekler
  Future<void> addBonusItems(int count) async {
    await init();
    final currentBonus = await _getBonusItems();
    await _setBonusItems(currentBonus + count);

    if (kDebugMode) {
      debugPrint(
        'ItemLimitService: $count bonus item eklendi. Toplam bonus: ${currentBonus + count}',
      );
    }
  }

  /// Kalan item hakkını döner (ücretsiz + bonus)
  Future<int> getRemainingItems() async {
    await init();

    // Remove Ads varsa sınırsız
    if (_purchaseService.removeAds.value) {
      return 999999; // Sınırsız sembolü
    }

    final totalAdded = await getTotalItemsAdded();
    final bonusItems = await _getBonusItems();

    // Henüz free limit'e ulaşmadıysa
    if (totalAdded < freeItemLimit) {
      return (freeItemLimit - totalAdded) + bonusItems;
    }

    // Free limit dolmuş, sadece bonus kaldı
    return bonusItems;
  }

  /// Toplam eklenen item sayısını döner
  Future<int> getTotalItemsAdded() async {
    await init();
    return _prefs?.getInt(_keyItemsAdded) ?? 0;
  }

  /// Toplam eklenen item sayısını ayarlar (internal)
  Future<void> _setTotalItemsAdded(int count) async {
    await init();
    await _prefs?.setInt(_keyItemsAdded, count);
  }

  /// Bonus item sayısını döner (internal)
  Future<int> _getBonusItems() async {
    await init();
    return _prefs?.getInt(_keyBonusItems) ?? 0;
  }

  /// Bonus item sayısını ayarlar (internal)
  Future<void> _setBonusItems(int count) async {
    await init();
    await _prefs?.setInt(_keyBonusItems, count);
  }

  /// Günlük reset kontrolü (opsiyonel - şu an kullanılmıyor)
  ///
  /// Eğer günlük reset istiyorsanız, her gün sayaçları sıfırlar.
  /// Şu anki implementasyonda lifetime bazında çalışıyor.
  Future<void> _checkDailyReset() async {
    final lastReset = _prefs?.getString(_keyLastResetDate);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (lastReset != null && lastReset != today) {
      // Yeni gün, sayaçları sıfırla (isterseniz aktifleştirin)
      // await reset();
      await _prefs?.setString(_keyLastResetDate, today);
    } else if (lastReset == null) {
      await _prefs?.setString(_keyLastResetDate, today);
    }
  }

  /// Sayaçları sıfırlar (test veya debug için)
  Future<void> reset() async {
    await init();
    await _prefs?.setInt(_keyItemsAdded, 0);
    await _prefs?.setInt(_keyBonusItems, 0);
    if (kDebugMode) {
      debugPrint('ItemLimitService: Sayaçlar sıfırlandı');
    }
  }

  /// Debug bilgisi döner
  Future<String> getDebugInfo() async {
    await init();
    final total = await getTotalItemsAdded();
    final bonus = await _getBonusItems();
    final remaining = await getRemainingItems();
    final hasRemoveAds = _purchaseService.removeAds.value;

    return '''
ItemLimitService Debug:
- Remove Ads: $hasRemoveAds
- Total Added: $total
- Bonus Items: $bonus
- Remaining: $remaining
- Can Add: ${await canAddItem()}
''';
  }
}
