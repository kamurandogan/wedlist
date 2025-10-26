import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/constants/firebase_constants.dart';
import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/user/app_user_model.dart';

class ProfileService {
  ProfileService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  Future<AppUserModel?> loadCurrent() async {
    final uid = _uid;
    if (uid == null) return null;

    try {
      final doc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(uid)
          .get();
      if (!doc.exists) return null;
      return AppUserModel.fromJson(doc.data() ?? {}, doc.id);
    } catch (e, s) {
      AppLogger.error('Failed to load profile', e, s);
      rethrow;
    }
  }

  Future<void> ensureProfileInfo() async {
    final uid = _uid;
    if (uid == null) return;

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final ref = _firestore.collection(FirebaseCollections.users).doc(uid);
      final snap = await ref.get();
      final data = snap.data() ?? {};

      final updates = <String, dynamic>{};

      if (data['name'] == null || (data['name'] as String).isEmpty) {
        updates['name'] = user.displayName ?? 'User';
      }

      if (data['email'] == null || (data['email'] as String).isEmpty) {
        updates['email'] = user.email ?? 'no-email';
      }

      if (updates.isNotEmpty) {
        await ref.set(updates, SetOptions(merge: true));
      }
    } catch (e, s) {
      AppLogger.error('Failed to ensure profile info', e, s);
    }
  }

  Future<void> addCustomCategory(String category) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      final ref = _firestore.collection(FirebaseCollections.users).doc(uid);
      await ref.set({
        'customCategories': FieldValue.arrayUnion([category]),
      }, SetOptions(merge: true));
    } catch (e, s) {
      AppLogger.error('Failed to add custom category', e, s);
      rethrow;
    }
  }
}
