import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Basit IAP servisi: iki non-consumable için ürün sorgulama ve satın alma akışı.
/// Ürün kimlikleri mağazalarda Non-Consumable olarak oluşturulmalıdır.
/// Platforma göre farklı productId kullanırız:
/// ANDROID (Google Play):
///  - com.wedlist.remove_ads
///  - com.wedlist.collab_unlock
/// iOS (App Store):
///  - com.kamurandev.wedlist.wedlist.remove_ads
///  - com.kamurandev.wedlist.wedlist.collab_unlock
class PurchaseService {
  // Android'de mevcut ID'leri koruyoruz
  static const String kRemoveAdsIdAndroid = 'com.wedlist.remove_ads';
  static const String kCollabUnlockIdAndroid = 'com.wedlist.collab_unlock';

  // iOS için benzersiz yeni ID'ler (App Store Connect'te bunları oluşturun)
  static const String kRemoveAdsIdIOS = 'com.kamurandev.wedlist.wedlist.remove_ads';
  static const String kCollabUnlockIdIOS = 'com.kamurandev.wedlist.wedlist.collab_unlock';

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  String get removeAdsId => _isIOS ? kRemoveAdsIdIOS : kRemoveAdsIdAndroid;
  String get collabUnlockId => _isIOS ? kCollabUnlockIdIOS : kCollabUnlockIdAndroid;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  bool _available = false;
  bool get isAvailable => _available;

  ProductDetails? removeAdsProduct;
  ProductDetails? collabUnlockProduct;

  // Entitlement state (kept in-memory and observable for UI)
  final ValueNotifier<bool> removeAds = ValueNotifier<bool>(false);
  final ValueNotifier<bool> collabUnlocked = ValueNotifier<bool>(false);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> init() async {
    _available = await _iap.isAvailable();
    if (!_available) return;
    _sub ??= _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _sub?.cancel(),
      onError: (Object error, [StackTrace? stackTrace]) {
        if (kDebugMode) {
          // ignore: avoid_print
          print('IAP stream error: $error');
        }
      },
    );
    await queryProducts();
    await _loadEntitlements();
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> queryProducts() async {
    final response = await _iap.queryProductDetails({
      removeAdsId,
      collabUnlockId,
    });
    if (response.error != null) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('IAP query error: ${response.error}');
      }
      return;
    }
    for (final p in response.productDetails) {
      if (p.id == removeAdsId) removeAdsProduct = p;
      if (p.id == collabUnlockId) collabUnlockProduct = p;
    }
  }

  Future<bool> buyRemoveAds() async {
    final p = removeAdsProduct ?? (await _fetchSingle(removeAdsId));
    if (p == null) return false;
    final param = PurchaseParam(productDetails: p);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<bool> buyCollabUnlock() async {
    final p = collabUnlockProduct ?? (await _fetchSingle(collabUnlockId));
    if (p == null) return false;
    final param = PurchaseParam(productDetails: p);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<ProductDetails?> _fetchSingle(String id) async {
    final r = await _iap.queryProductDetails({id});
    if (r.productDetails.isEmpty) return null;
    return r.productDetails.first;
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final pd in purchases) {
      switch (pd.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Minimum: teslim et ve satın almayı tamamla (acknowledge/consume gerekmiyor non-consumable için)
          // Not: Üretimde sunucu doğrulaması eklemeniz önerilir.
          _deliver(pd);
          _iap.completePurchase(pd);
        case PurchaseStatus.error:
          break;
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  Future<void> _deliver(PurchaseDetails pd) async {
    if (kDebugMode) {
      // ignore: avoid_print
      print('Deliver purchase: ${pd.productID}');
    }
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      // Kullanıcı oturumu yoksa sadece yerel state'i güncelle (geçici)
      if (pd.productID == removeAdsId) removeAds.value = true;
      if (pd.productID == collabUnlockId) collabUnlocked.value = true;
      return;
    }
    final ref = _firestore.collection('users').doc(uid);
    final premium = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (pd.productID == removeAdsId) {
      premium['removeAds'] = true;
      removeAds.value = true;
    }
    if (pd.productID == collabUnlockId) {
      premium['collabUnlocked'] = true;
      collabUnlocked.value = true;
    }
    final patch = <String, dynamic>{'premium': premium};
    try {
      await ref.set(patch, SetOptions(merge: true));
    } on FirebaseException catch (_) {
      // yut: ağ/firestore hataları
    } on Exception catch (_) {
      // yut: diğer hatalar
    }
  }

  Future<void> _loadEntitlements() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data() ?? <String, dynamic>{};
      final premium = (data['premium'] is Map)
          ? (data['premium'] as Map).cast<String, dynamic>()
          : <String, dynamic>{};
      removeAds.value = (premium['removeAds'] as bool?) ?? false;
      collabUnlocked.value = (premium['collabUnlocked'] as bool?) ?? false;
    } on FirebaseException catch (_) {
      // ignore
    } on Exception catch (_) {
      // ignore
    }
  }
}
