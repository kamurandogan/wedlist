// ignore_for_file: one_member_abstracts

import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/item/item_model.dart' as core;
import 'package:wedlist/feature/wishlist/data/models/category_item_model.dart';

/// Kategori verilerini uzak kaynaktan (ör. Firestore) çeken soyut veri kaynağı arayüzü.
abstract class CategoryRemoteDataSource {
  /// Belirli bir başlık ve dil koduna göre kategori listesini getirir.
  Future<List<CategoryItemModel>> getCategories(String title, String langCode);
  // Future<List<String>> getFirebaseKeys();
}

/// Firestore'dan kategori verilerini çeken veri kaynağı implementasyonu.
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  /// Firestore instance'ı ile kurucu
  CategoryRemoteDataSourceImpl(this.firestore, [FirebaseAuth? auth]) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore firestore;
  final FirebaseAuth _auth;

  /// Firestore'dan kategori listesini getirir.
  /// [title]: Belirli bir başlık (kullanılmıyor, ileride filtre için eklenebilir)
  /// [langCode]: Dil kodu (ör. 'en', 'tr')
  @override
  Future<List<CategoryItemModel>> getCategories(String title, String langCode) async {
    final uid = _auth.currentUser?.uid;
    final categories = <String>{};
    final country = await _resolveCountry(uid);

    if (uid != null && uid.isNotEmpty) {
      // Önce kullanıcının wishlist'indeki kategoriler
      final userSnap = await firestore.collection('users').doc(uid).get();
      final rawList = (userSnap.data()?['wishList'] as List?)?.cast<Map<String, dynamic>>();
      if (rawList != null && rawList.isNotEmpty) {
        for (final j in rawList) {
          final m = core.ItemModel.fromJson(j);
          categories.add(m.category);
        }
      }

      // İşbirlikçilerinin (collaborators) wishlist kategorilerini de ekle
      final collabs = (userSnap.data()?['collaborators'] as List?)?.whereType<String>().toList() ?? const <String>[];
      if (collabs.isNotEmpty) {
        try {
          final futures = <Future<DocumentSnapshot<Map<String, dynamic>>>>[
            for (final cUid in collabs) firestore.collection('users').doc(cUid).get(),
          ];
          final snaps = await Future.wait(futures);
          for (final s in snaps) {
            final cRaw = (s.data()?['wishList'] as List?)?.cast<Map<String, dynamic>>();
            if (cRaw == null || cRaw.isEmpty) continue;
            for (final j in cRaw) {
              final m = core.ItemModel.fromJson(j);
              categories.add(m.category);
            }
          }
        } on Exception catch (_) {
          // Collaborator verileri okunamazsa sessizce yoksay (rules veya ağ vs.)
        }
      }
    }

    // Fallback: base items'tan kategoriler (ör. wishlist boşsa)
    if (categories.isEmpty) {
      final baseQuery = await firestore.collection('items_${country.toUpperCase()}').get();
      for (final doc in baseQuery.docs) {
        final cat = doc.data()['category'];
        if (cat is String && cat.isNotEmpty) categories.add(cat);
      }
    }

    return categories.map((cat) => CategoryItemModel(title: cat)).toList();
  }

  // @override
  // Future<List<String>> getFirebaseKeys() async {
  //   final docSnapshot = await firestore.collection('wishLists').doc('wishlist_en').get();
  //   final data = docSnapshot.data();
  //   if (data == null) return [];

  //   final categoryData = data['wishListItems']['category'];

  //   final keys = <String>[];

  //   if (categoryData != null) {
  //     categoryData.forEach(
  //       (key, value) {
  //         keys.add(key);
  //       },
  //     );
  //   }
  //   print('Firebase Keys: $keys');
  //   return keys;
  // }
}

extension on CategoryRemoteDataSourceImpl {
  Future<String> _resolveCountry(String? uid) async {
    // 1) Try user profile country
    try {
      if (uid != null && uid.isNotEmpty) {
        final snap = await firestore.collection('users').doc(uid).get();
        final c = (snap.data()?['country'] as String?)?.toUpperCase();
        if (c != null && c.isNotEmpty) return c;
      }
    } on Exception catch (_) {}
    // 2) Infer from device locale
    final loc = ui.PlatformDispatcher.instance.locale;
    final lang = loc.languageCode.toLowerCase();
    final region = (loc.countryCode ?? '').toUpperCase();
    if (region.isNotEmpty) return region;
    switch (lang) {
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
}
