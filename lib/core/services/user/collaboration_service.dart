import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/constants/firebase_constants.dart';
import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/user/app_user_model.dart';

class CollaborationService {
  CollaborationService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> ensureSymmetricCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    
    try {
      final selfRef = _firestore.collection(FirebaseCollections.users).doc(uid);
      final meSnap = await selfRef.get();
      final me = AppUserModel.fromJson(meSnap.data() ?? {}, uid);
      final removed = (meSnap.data()?['removedCollaborators'] as List?)?.cast<String>() ?? [];
      
      final q = await _firestore.collection(FirebaseCollections.users).where('collaborators', arrayContains: uid).get();
      if (q.docs.isEmpty) return;
      
      final existing = me.collaborators.toSet();
      final toAdd = <String>{};
      
      for (final d in q.docs) {
        final otherId = d.id;
        if (otherId == uid) continue;
        if (removed.contains(otherId)) continue;
        if (!existing.contains(otherId)) toAdd.add(otherId);
      }
      
      if (toAdd.isNotEmpty) {
        await selfRef.set({'collaborators': FieldValue.arrayUnion(toAdd.toList())}, SetOptions(merge: true));
      }
    } on Exception catch (e, s) {
      AppLogger.error('Failed to ensure symmetric collaborators', e, s);
    }
  }

  Future<void> cleanUpAsymmetricCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    
    try {
      final selfRef = _firestore.collection(FirebaseCollections.users).doc(uid);
      final meSnap = await selfRef.get();
      final me = AppUserModel.fromJson(meSnap.data() ?? {}, uid);
      if (me.collaborators.isEmpty) return;
      
      final toRemove = <String>[];
      
      for (final cid in me.collaborators) {
        try {
          final other = await _firestore.collection(FirebaseCollections.users).doc(cid).get();
          final otherData = other.data() ?? {};
          final otherCollabs = (otherData['collaborators'] as List?)?.cast<String>() ?? [];
          final otherRemoved = (otherData['removedCollaborators'] as List?)?.cast<String>() ?? [];
          
          if (!otherCollabs.contains(uid) || otherRemoved.contains(uid)) {
            toRemove.add(cid);
          }
        } on Exception {
          toRemove.add(cid);
        }
      }
      
      if (toRemove.isNotEmpty) {
        await selfRef.set({'collaborators': FieldValue.arrayRemove(toRemove)}, SetOptions(merge: true));
      }
    } on Exception catch (e, s) {
      AppLogger.error('Failed to cleanup asymmetric collaborators', e, s);
    }
  }

  Future<void> ensureUserItemsSymmetric() async {
    final uid = _uid;
    if (uid == null) return;
    
    try {
      final userSnap = await _firestore.collection(FirebaseCollections.users).doc(uid).get();
      final me = AppUserModel.fromJson(userSnap.data() ?? {}, uid);
      if (me.collaborators.isEmpty) return;
      
      final partnerUid = me.collaborators.first;
      if (partnerUid == uid) return;
      
      final mine = await _firestore.collection(FirebaseCollections.userItems).where('owners', arrayContains: uid).get();
      final batch = _firestore.batch();
      var changed = 0;
      
      for (final d in mine.docs) {
        final owners = (d.data()['owners'] as List?)?.cast<String>() ?? [];
        if (!owners.contains(partnerUid)) {
          batch.update(d.reference, {'owners': FieldValue.arrayUnion([partnerUid])});
          changed++;
        }
      }
      
      if (changed > 0) {
        await batch.commit();
      }
    } on Exception catch (e, s) {
      AppLogger.error('Failed to ensure user items symmetric', e, s);
    }
  }

  Future<void> shareAllItemsWithPartner(String partnerUid) async {
    final uid = _uid;
    if (uid == null || uid == partnerUid) return;
    
    try {
      final items = await _firestore.collection(FirebaseCollections.userItems).where('owners', arrayContains: uid).get();
      final batch = _firestore.batch();
      for (final d in items.docs) {
        batch.update(d.reference, {'owners': FieldValue.arrayUnion([partnerUid])});
      }
      await batch.commit();
    } on Exception catch (e, s) {
      AppLogger.error('Failed to share items with partner', e, s);
    }
  }

  Future<void> sharePartnerItemsWithMe(String partnerUid) async {
    final uid = _uid;
    if (uid == null || uid == partnerUid) return;
    
    try {
      final items = await _firestore.collection(FirebaseCollections.userItems).where('owners', arrayContains: partnerUid).get();
      final batch = _firestore.batch();
      for (final d in items.docs) {
        batch.update(d.reference, {'owners': FieldValue.arrayUnion([uid])});
      }
      await batch.commit();
    } on Exception catch (e, s) {
      AppLogger.error('Failed to get partner items', e, s);
    }
  }

  Future<void> setSinglePartner(String partnerUid) async {
    final uid = _uid;
    if (uid == null || uid == partnerUid) return;
    
    try {
      final users = _firestore.collection(FirebaseCollections.users);
      final selfRef = users.doc(uid);
      final partnerRef = users.doc(partnerUid);
      
      final selfSnap = await selfRef.get();
      final partnerSnap = await partnerRef.get();
      final selfModel = AppUserModel.fromJson(selfSnap.data() ?? {}, uid);
      final partnerModel = AppUserModel.fromJson(partnerSnap.data() ?? {}, partnerUid);
      
      final prevMine = selfModel.collaborators.where((e) => e != partnerUid).toSet();
      final prevTheirs = partnerModel.collaborators.where((e) => e != uid).toSet();
      
      await selfRef.set({
        'collaborators': [partnerUid],
        if (prevMine.isNotEmpty) 'removedCollaborators': FieldValue.arrayUnion(prevMine.toList()),
      }, SetOptions(merge: true));
      
      for (final old in prevMine) {
        try {
          await users.doc(old).set({
            'collaborators': FieldValue.arrayRemove([uid]),
            'removedCollaborators': FieldValue.arrayUnion([uid]),
          }, SetOptions(merge: true));
        } on Exception {
          // ignore
        }
      }
      
      await partnerRef.set({
        'collaborators': [uid],
        if (prevTheirs.isNotEmpty) 'removedCollaborators': FieldValue.arrayUnion(prevTheirs.toList()),
      }, SetOptions(merge: true));
      
      for (final old in prevTheirs) {
        try {
          await users.doc(old).set({
            'collaborators': FieldValue.arrayRemove([partnerUid]),
            'removedCollaborators': FieldValue.arrayUnion([partnerUid]),
          }, SetOptions(merge: true));
        } on Exception {
          // ignore  
        }
      }
    } on Exception catch (e, s) {
      AppLogger.error('Failed to set single partner', e, s);
    }
  }
}
