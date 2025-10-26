import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/constants/firebase_constants.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/item/item_model.dart' as core;
import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/user/app_user_model.dart';

class WishlistInitializationService {
  WishlistInitializationService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> ensureWishListInitialized() async {
    final uid = _uid;
    if (uid == null) return;
    
    try {
      final ref = _firestore.collection(FirebaseCollections.users).doc(uid);
      final snap = await ref.get();
      final user = AppUserModel.fromJson(snap.data() ?? {}, uid);
      
      if (user.wishList.isNotEmpty) return;
      
      final country = await _resolveCountryFromData(snap.data());
      final base = await _firestore.collection(FirebaseCollections.itemsByCountry(country)).get();
      
      final items = base.docs.map((d) => core.ItemModel.fromJson({
        'id': d.data()['id'] ?? d.id,
        'title': d.data()['title'],
        'category': d.data()['category'],
      })).map((m) => m.toJson()).toList();
      
      await ref.set({'wishList': items}, SetOptions(merge: true));
    } catch (e, s) {
      AppLogger.error('Failed to initialize wishlist', e, s);
    }
  }

  Future<void> mergeWishListWithCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    
    try {
      final selfRef = _firestore.collection(FirebaseCollections.users).doc(uid);
      final selfSnap = await selfRef.get();
      final selfModel = AppUserModel.fromJson(selfSnap.data() ?? {}, uid);
      final collabIds = selfModel.collaborators;
      
      if (collabIds.isEmpty) return;
      
      String norm(String s) => s.trim().toLowerCase();
      String key(ItemEntity e) => '${norm(e.category)}|${norm(e.title)}';
      
      final byKey = <String, ItemEntity>{
        for (final e in selfModel.wishList) key(e): e,
      };
      
      for (final cid in collabIds) {
        try {
          final p = await _firestore.collection(FirebaseCollections.users).doc(cid).get();
          final pm = AppUserModel.fromJson(p.data() ?? {}, cid);
          for (final e in pm.wishList) {
            byKey.putIfAbsent(key(e), () => e);
          }
        } catch (e) {
          // ignore
        }
      }
      
      final mergedJson = byKey.values.map((e) => core.ItemModel.fromEntity(e).toJson()).toList();
      await selfRef.set({'wishList': mergedJson}, SetOptions(merge: true));
    } catch (e, s) {
      AppLogger.error('Failed to merge wishlist with collaborators', e, s);
    }
  }

  Future<void> importPartnerWishListOnce(String partnerUid) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      final selfRef = _firestore.collection(FirebaseCollections.users).doc(uid);
      final partnerRef = _firestore.collection(FirebaseCollections.users).doc(partnerUid);
      final self = await selfRef.get();
      final partner = await partnerRef.get();
      final selfModel = AppUserModel.fromJson(self.data() ?? {}, uid);
      final partnerModel = AppUserModel.fromJson(partner.data() ?? {}, partnerUid);

      String norm(String s) => s.trim().toLowerCase();
      String key(ItemEntity e) => '${norm(e.category)}|${norm(e.title)}';

      final byKey = <String, ItemEntity>{
        for (final e in selfModel.wishList) key(e): e,
      };
      for (final e in partnerModel.wishList) {
        byKey.putIfAbsent(key(e), () => e);
      }

      final mergedJson = byKey.values.map((e) => core.ItemModel.fromEntity(e).toJson()).toList();
      await selfRef.set({'wishList': mergedJson}, SetOptions(merge: true));
    } catch (e, s) {
      AppLogger.error('Failed to import partner wishlist', e, s);
    }
  }

  Future<void> importSelfWishListInto(String partnerUid) async {
    final uid = _uid;
    if (uid == null || uid == partnerUid) return;

    try {
      final users = _firestore.collection(FirebaseCollections.users);
      final selfSnap = await users.doc(uid).get();
      final partnerSnap = await users.doc(partnerUid).get();
      final selfModel = AppUserModel.fromJson(selfSnap.data() ?? {}, uid);
      final partnerModel = AppUserModel.fromJson(partnerSnap.data() ?? {}, partnerUid);

      String norm(String s) => s.trim().toLowerCase();
      String key(ItemEntity e) => '${norm(e.category)}|${norm(e.title)}';

      final byKey = <String, ItemEntity>{
        for (final e in partnerModel.wishList) key(e): e,
      };
      for (final e in selfModel.wishList) {
        byKey.putIfAbsent(key(e), () => e);
      }

      final mergedJson = byKey.values.map((e) => core.ItemModel.fromEntity(e).toJson()).toList();
      await users.doc(partnerUid).set({'wishList': mergedJson}, SetOptions(merge: true));
    } catch (e, s) {
      AppLogger.error('Failed to import self wishlist into partner', e, s);
    }
  }

  Future<String> _resolveCountryFromData(Map<String, dynamic>? data) async {
    if (data != null && data.containsKey('country')) {
      return (data['country'] as String).toUpperCase();
    }
    final locale = ui.PlatformDispatcher.instance.locale;
    return locale.countryCode?.toUpperCase() ?? 'US';
  }
}
