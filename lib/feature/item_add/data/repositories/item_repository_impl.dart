import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/item_add/domain/repositories/item_repository.dart';

/// ItemRepository arayüzünü uygulayan repository sınıfı.
/// Firestore'dan item (ürün) verisi çeker.
class ItemRepositoryImpl implements ItemRepository {
  @override
  Future<ItemEntity?> fetchItemById(String id, {String? category}) async {
    var docId = id;
    if (category != null && category.isNotEmpty) {
      docId = '${category.replaceAll(' ', '_').toLowerCase()}_$id';
    }

    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final collection = await _resolveItemsCollection(firestore, auth);
    final doc = await firestore.collection(collection).doc(docId).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return ItemEntity(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
    );
  }

  Future<String> _resolveItemsCollection(
    FirebaseFirestore firestore,
    FirebaseAuth auth,
  ) async {
    // Try user profile country
    final uid = auth.currentUser?.uid;
    String? code;
    if (uid != null) {
      try {
        final snap = await firestore.collection('users').doc(uid).get();
        code = (snap.data()?['country'] as String?)?.toUpperCase();
      } on Exception catch (_) {}
    }
    // Fallback to device region code
    code ??= (ui.PlatformDispatcher.instance.locale.countryCode ?? '')
        .toUpperCase();
    if (code.isEmpty) code = 'TR';
    return 'items_$code';
  }
}
