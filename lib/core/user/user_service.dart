import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/item/item_model.dart' as core;
import 'package:wedlist/core/user/app_user_model.dart';

class UserService {
  UserService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  Future<AppUserModel?> loadCurrent() async {
    final uid = _uid;
    if (uid == null) return null;
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUserModel.fromJson(doc.data() ?? <String, dynamic>{}, doc.id);
  }

  Future<void> ensureWishListInitialized() async {
    final uid = _uid;
    if (uid == null) return;
    final ref = _firestore.collection('users').doc(uid);
    final snap = await ref.get();
    final user = AppUserModel.fromJson(snap.data() ?? {}, uid);
    if (user.wishList.isNotEmpty) return;
    // Initialize wishList with all base items if empty (country-specific)
    final country = await _resolveCountryFromData(snap.data());
    final base = await _firestore.collection('items_${country.toUpperCase()}').get();
    final items = base.docs
        .map(
          (d) => core.ItemModel.fromJson({
            'id': d.data()['id'] ?? d.id,
            'title': d.data()['title'],
            'category': d.data()['category'],
          }),
        )
        .map((m) => m.toJson())
        .toList();
    await ref.set({'wishList': items}, SetOptions(merge: true));
  }

  /// Migrate legacy string-based wishList/receivedList to a list of item JSON maps.
  Future<void> migrateLegacyStringListsIfNeeded() async {
    final uid = _uid;
    if (uid == null) return;
    final ref = _firestore.collection('users').doc(uid);
    final snap = await ref.get();
    if (!snap.exists) return;
    final data = snap.data() ?? <String, dynamic>{};
    final wl = (data['wishList'] as List?) ?? const <dynamic>[];
    final rl = (data['receivedList'] as List?) ?? const <dynamic>[];
    bool isStringList(List<dynamic> list) => list.isNotEmpty && list.every((e) => e is String);
    if (!isStringList(wl) && !isStringList(rl)) return;

    // Build title->ItemEntity map from base items and user-visible custom items.
    final titleMap = <String, ItemEntity>{};
    final country = (data['country'] as String?)?.toUpperCase();
    final col = country != null && country.isNotEmpty ? 'items_$country' : 'items_US';
    final base = await _firestore.collection(col).get();
    for (final d in base.docs) {
      final m = core.ItemModel.fromJson({
        'id': d.data()['id'] ?? d.id,
        'title': d.data()['title'],
        'category': d.data()['category'],
      });
      final e = m.toEntity();
      titleMap[e.title.trim().toLowerCase()] = e;
    }

    final meModel = AppUserModel.fromJson(data, uid);
    final owners = {uid, ...meModel.collaborators}.toList();
    final custom = await _firestore.collection('customItems').where('owners', arrayContainsAny: owners).get();
    for (final d in custom.docs) {
      final m = core.ItemModel.fromJson({
        'id': d.data()['id'] ?? d.id,
        'title': d.data()['title'],
        'category': d.data()['category'],
      });
      final e = m.toEntity();
      titleMap[e.title.trim().toLowerCase()] = e;
    }

    List<Map<String, dynamic>> convert(List<dynamic> list) {
      if (isStringList(list)) {
        final res = <Map<String, dynamic>>[];
        for (final s in list.cast<String>()) {
          final key = s.trim().toLowerCase();
          final found = titleMap[key];
          if (found != null) {
            res.add(core.ItemModel.fromEntity(found).toJson());
          } else {
            final id = key.replaceAll(' ', '_');
            res.add({'id': id, 'title': s, 'category': 'General'});
          }
        }
        return res;
      }
      return list.whereType<Map<String, dynamic>>().toList();
    }

    final newWL = convert(wl);
    final newRL = convert(rl);
    await ref.set({'wishList': newWL, 'receivedList': newRL}, SetOptions(merge: true));
  }

  Future<void> addCustomCategory(String category) async {
    final uid = _uid;
    if (uid == null) return;
    final ref = _firestore.collection('users').doc(uid);
    // Kategoriyi kullanıcı profiline bilgi amaçlı kaydet (wishList artık ItemEntity listesi)
    await ref.set({
      'customCategories': FieldValue.arrayUnion([category]),
    }, SetOptions(merge: true));
  }

  /// When a partner is added, import their wishList into current user's wishList once.
  Future<void> importPartnerWishListOnce(String partnerUid) async {
    final uid = _uid;
    if (uid == null) return;
    final selfRef = _firestore.collection('users').doc(uid);
    final partnerRef = _firestore.collection('users').doc(partnerUid);
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
  }

  /// Merge current user's wishList with all collaborators' wishLists (idempotent union).
  Future<void> mergeWishListWithCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    final selfRef = _firestore.collection('users').doc(uid);
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
        final p = await _firestore.collection('users').doc(cid).get();
        final pm = AppUserModel.fromJson(p.data() ?? {}, cid);
        for (final e in pm.wishList) {
          byKey.putIfAbsent(key(e), () => e);
        }
      } on Exception {
        // ignore and continue
      }
    }
    final mergedJson = byKey.values.map((e) => core.ItemModel.fromEntity(e).toJson()).toList();
    await selfRef.set({'wishList': mergedJson}, SetOptions(merge: true));
  }

  /// Enforce single partner: set both users' collaborators to point to each other only.
  /// Also marks previous partners as removed to avoid auto re-adding.
  Future<void> setSinglePartner(String partnerUid) async {
    final uid = _uid;
    if (uid == null) return;
    if (uid == partnerUid) return;

    final users = _firestore.collection('users');
    final selfRef = users.doc(uid);
    final partnerRef = users.doc(partnerUid);

    // Fetch both profiles
    final selfSnap = await selfRef.get();
    final partnerSnap = await partnerRef.get();
    final selfModel = AppUserModel.fromJson(selfSnap.data() ?? {}, uid);
    final partnerModel = AppUserModel.fromJson(partnerSnap.data() ?? {}, partnerUid);

    final prevMine = selfModel.collaborators.where((e) => e != partnerUid).toSet();
    final prevTheirs = partnerModel.collaborators.where((e) => e != uid).toSet();

    // Update self -> only partnerUid
    await selfRef.set({
      'collaborators': [partnerUid],
      if (prevMine.isNotEmpty) 'removedCollaborators': FieldValue.arrayUnion(prevMine.toList()),
    }, SetOptions(merge: true));

    // Remove myself from previous partners and mark removed
    for (final old in prevMine) {
      try {
        final r = users.doc(old);
        await r.set({
          'collaborators': FieldValue.arrayRemove([uid]),
          'removedCollaborators': FieldValue.arrayUnion([uid]),
        }, SetOptions(merge: true));
      } on Exception {
        // best-effort
      }
    }

    // Update partner -> only uid
    await partnerRef.set({
      'collaborators': [uid],
      if (prevTheirs.isNotEmpty) 'removedCollaborators': FieldValue.arrayUnion(prevTheirs.toList()),
    }, SetOptions(merge: true));

    // Remove partner from their previous partners
    for (final old in prevTheirs) {
      try {
        final r = users.doc(old);
        await r.set({
          'collaborators': FieldValue.arrayRemove([partnerUid]),
          'removedCollaborators': FieldValue.arrayUnion([partnerUid]),
        }, SetOptions(merge: true));
      } on Exception {
        // best-effort
      }
    }
  }

  /// Share all my existing user items with the partner, so they immediately see my list.
  Future<void> shareAllItemsWithPartner(String partnerUid) async {
    final uid = _uid;
    if (uid == null) return;
    if (uid == partnerUid) return;
    final items = await _firestore.collection('userItems').where('owners', arrayContains: uid).get();
    final batch = _firestore.batch();
    for (final d in items.docs) {
      batch.update(d.reference, {
        'owners': FieldValue.arrayUnion([partnerUid]),
      });
    }
    await batch.commit();
  }

  /// Share partner's existing user items with me, so I immediately see their list.
  Future<void> sharePartnerItemsWithMe(String partnerUid) async {
    final uid = _uid;
    if (uid == null) return;
    if (uid == partnerUid) return;
    final items = await _firestore.collection('userItems').where('owners', arrayContains: partnerUid).get();
    final batch = _firestore.batch();
    for (final d in items.docs) {
      batch.update(d.reference, {
        'owners': FieldValue.arrayUnion([uid]),
      });
    }
    await batch.commit();
  }

  /// Merge my wishList into the partner's wishList (idempotent union), so they see my base list.
  Future<void> importSelfWishListInto(String partnerUid) async {
    final uid = _uid;
    if (uid == null) return;
    if (uid == partnerUid) return;
    final users = _firestore.collection('users');
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
  }

  /// Ensure collaborator links are symmetric: if someone has already added me,
  /// add them to my collaborators as well.
  Future<void> ensureSymmetricCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    final selfRef = _firestore.collection('users').doc(uid);
    final meSnap = await selfRef.get();
    final me = AppUserModel.fromJson(meSnap.data() ?? {}, uid);
    final removed = (meSnap.data()?['removedCollaborators'] as List?)?.cast<String>() ?? const <String>[];
    // Find users that already list me as collaborator
    final q = await _firestore.collection('users').where('collaborators', arrayContains: uid).get();
    if (q.docs.isEmpty) return;
    final existing = me.collaborators.toSet();
    final toAdd = <String>{};
    for (final d in q.docs) {
      final otherId = d.id;
      if (otherId == uid) continue;
      if (removed.contains(otherId)) continue; // daha önce ben sildiysem ekleme
      if (!existing.contains(otherId)) toAdd.add(otherId);
    }
    if (toAdd.isEmpty) return;
    await selfRef.set({'collaborators': FieldValue.arrayUnion(toAdd.toList())}, SetOptions(merge: true));
  }

  /// Ensure current user's profile has at least email (and name if available).
  /// This helps collaborator UIs show proper info even for legacy users.
  Future<void> ensureProfileInfo() async {
    final uid = _uid;
    if (uid == null) return;
    final user = _auth.currentUser;
    if (user == null) return;
    final ref = _firestore.collection('users').doc(uid);
    final snap = await ref.get();
    final data = snap.data() ?? <String, dynamic>{};
    final currentEmail = (data['email'] as String?) ?? '';
    final currentName = (data['name'] as String?) ?? '';
    final patch = <String, dynamic>{};
    if (currentEmail.trim().isEmpty && (user.email ?? '').isNotEmpty) {
      patch['email'] = user.email!.trim().toLowerCase();
    }
    if (currentName.trim().isEmpty && (user.displayName ?? '').isNotEmpty) {
      patch['name'] = user.displayName;
    }
    if (patch.isNotEmpty) {
      await ref.set(patch, SetOptions(merge: true));
    }
  }

  /// Remove collaborators who no longer list me or explicitly removed me.
  Future<void> cleanUpAsymmetricCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    final selfRef = _firestore.collection('users').doc(uid);
    final meSnap = await selfRef.get();
    final me = AppUserModel.fromJson(meSnap.data() ?? {}, uid);
    if (me.collaborators.isEmpty) return;
    final toRemove = <String>[];
    for (final cid in me.collaborators) {
      try {
        final other = await _firestore.collection('users').doc(cid).get();
        final otherData = other.data() ?? <String, dynamic>{};
        final otherCollabs = (otherData['collaborators'] as List?)?.cast<String>() ?? const <String>[];
        final otherRemoved = (otherData['removedCollaborators'] as List?)?.cast<String>() ?? const <String>[];
        final iAmListed = otherCollabs.contains(uid);
        final iAmRemoved = otherRemoved.contains(uid);
        if (!iAmListed || iAmRemoved) {
          toRemove.add(cid);
        }
      } on Exception {
        // If other doc missing or unreadable, remove it locally
        toRemove.add(cid);
      }
    }
    if (toRemove.isNotEmpty) {
      await selfRef.set({'collaborators': FieldValue.arrayRemove(toRemove)}, SetOptions(merge: true));
    }
  }

  /// Ensure all my userItems include my partner (single partner scenario).
  /// Note: We cannot mutate partner's items here due to security rules; their client must do the same.
  Future<void> ensureUserItemsSymmetric() async {
    final uid = _uid;
    if (uid == null) return;
    final userSnap = await _firestore.collection('users').doc(uid).get();
    final me = AppUserModel.fromJson(userSnap.data() ?? {}, uid);
    if (me.collaborators.isEmpty) return; // no partner
    // Single partner assumption (take first). If extended later, loop all.
    final partnerUid = me.collaborators.first;
    if (partnerUid == uid) return;
    final itemsCol = _firestore.collection('userItems');
    // 1. My items missing partner
    try {
      final mine = await itemsCol.where('owners', arrayContains: uid).get();
      final batch = _firestore.batch();
      var changed = 0;
      for (final d in mine.docs) {
        final owners = (d.data()['owners'] as List?)?.cast<String>() ?? const <String>[];
        if (!owners.contains(partnerUid)) {
          batch.update(d.reference, {
            'owners': FieldValue.arrayUnion([partnerUid]),
          });
          changed++;
        }
      }
      if (changed > 0) {
        await batch.commit();
      }
    } on Exception {
      // ignore
    }
    // 2. Partner items missing me (removed)
    // Not allowed by current security rules: you cannot update a document where you are not yet an owner.
    // This must be performed by the partner's client (adding me to their items) or via a privileged backend.
  }
}

extension _CountryResolve on UserService {
  Future<String> _resolveCountryFromData(Map<String, dynamic>? userData) async {
    final c = (userData?['country'] as String?)?.toUpperCase();
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
}
