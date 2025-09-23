import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/item/item_model.dart' as core;

/// Wishlist verilerini uzak kaynaktan (Firestore) çeken soyut veri kaynağı arayüzü
abstract class WishListRemoteDataSource {
  /// Belirli bir kategoriye göre wishlist itemlarını getirir
  Future<List<ItemEntity>> getItems(
    String category,
    String langCode,
    String id,
  );

  /// Belirli bir kategoriye birden fazla wishlist item ekler
  Future<void> addItems(String category, List<String> titles);
}

/// Firestore'dan wishlist verilerini çeken veri kaynağı implementasyonu (yeni düzleştirilmiş yapı)
class WishListRemoteDataSourceImpl implements WishListRemoteDataSource {
  WishListRemoteDataSourceImpl(this.firestore, [FirebaseAuth? auth])
    : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore firestore;
  final FirebaseAuth _auth;

  /// Firestore'dan ilgili kategoriye göre kullanıcının wishlist'ini getirir
  @override
  Future<List<ItemEntity>> getItems(
    String category,
    String langCode,
    String id,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw StateError('Giriş gerekli');
    }

    final userRef = firestore.collection('users').doc(uid);
    final userSnap = await userRef.get();
    final data = userSnap.data() ?? <String, dynamic>{};
    final rawList = (data['wishList'] as List?)?.cast<Map<String, dynamic>>();
    final country = await _resolveCountryFromData(data);
    List<core.ItemModel> models;
    if (rawList != null && rawList.isNotEmpty) {
      models = rawList.map(core.ItemModel.fromJson).toList();
    } else {
      // Kullanıcının listesi boşsa base items'i sadece oku (yazmadan)
      final base = await firestore
          .collection('items_${country.toUpperCase()}')
          .get();
      models = base.docs
          .map(
            (doc) => core.ItemModel.fromJson({
              'id': doc.data()['id'] ?? doc.id,
              'title': doc.data()['title'],
              'category': doc.data()['category'],
            }),
          )
          .toList();
      // İstek: base items kullanıcı wishlist'ine eklensin (persist)
      await userRef.set({
        'wishList': models.map((m) => m.toJson()).toList(),
      }, SetOptions(merge: true));
    }
    // Deduplicate by normalized category+title (ids may differ across sources)
    String norm(String s) => s.trim().toLowerCase();
    String keyOf(core.ItemModel m) => '${norm(m.category)}|${norm(m.title)}';
    final seen = <String>{};
    final unique = <core.ItemModel>[];
    for (final m in models) {
      final k = keyOf(m);
      if (seen.add(k)) unique.add(m);
    }
    if (unique.length != models.length) {
      // Persist cleaned list (best-effort)
      try {
        await userRef.set({
          'wishList': unique.map((m) => m.toJson()).toList(),
        }, SetOptions(merge: true));
      } on Exception {
        // ignore
      }
    }

    // Entitiy'e çevir ve kategori filtresi uygula
    final entities = unique.map((m) => m.toEntity()).toList();
    final filtered = category.isEmpty
        ? entities
        : entities.where((e) => e.category == category).toList();
    return filtered;
  }

  Future<String> _resolveCountryFromData(Map<String, dynamic> userData) async {
    final c = (userData['country'] as String?)?.toUpperCase();
    if (c != null && c.isNotEmpty) return c;
    final loc = ui.PlatformDispatcher.instance.locale;
    final region = (loc.countryCode ?? '').toUpperCase();
    if (region.isNotEmpty) return region;
    switch (loc.languageCode) {
      case 'tr':
        return 'TR';
      case 'de':
        return 'DE';
      case 'fr':
        return 'FR';
      case 'it':
        return 'IT';
      case 'ja':
        return 'JP';
      case 'en':
      default:
        return 'US';
    }
  }

  @override
  Future<void> addItems(String category, List<String> titles) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw StateError('Giriş gerekli');
    }

    String slug(String s) =>
        s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    String makeId(String cat, String title) =>
        'custom_${slug(cat)}_${slug(title)}';

    final userRef = firestore.collection('users').doc(uid);
    final snap = await userRef.get();
    final data = snap.data() ?? <String, dynamic>{};
    final current = ((data['wishList'] as List?) ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(core.ItemModel.fromJson)
        .toList();

    final existingKeys = <String>{
      for (final m in current) '${slug(m.category)}|${slug(m.title)}',
    };

    final toAppend = <core.ItemModel>[];
    for (final raw in titles) {
      final t = raw.trim();
      if (t.isEmpty) continue;
      final key = '${slug(category)}|${slug(t)}';
      if (existingKeys.contains(key)) continue;
      toAppend.add(
        core.ItemModel(
          id: makeId(category, t),
          title: t,
          category: category,
        ),
      );
      existingKeys.add(key);
    }

    if (toAppend.isEmpty) return;
    final updated = <core.ItemModel>[...current, ...toAppend];
    await userRef.set({
      'wishList': updated.map((m) => m.toJson()).toList(),
    }, SetOptions(merge: true));
  }
}
