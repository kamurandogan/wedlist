import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/feature/notification/data/models/app_notification_model.dart';

abstract class NotificationRemoteDataSource {
  Stream<List<AppNotificationModel>> watchMyNotifications();
  Future<void> addNotification(AppNotificationModel model);
  Future<void> markRead(Set<String> ids);
  Future<void> deleteMy(String id);
  Future<void> sendTo(String toUid, AppNotificationModel model);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl(this.firestore, this.auth);
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      firestore.collection('users').doc(uid).collection('notifications');

  @override
  Stream<List<AppNotificationModel>> watchMyNotifications() {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      return const Stream.empty();
    }
    return _col(uid)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map((d) => AppNotificationModel.fromJson(d.data(), d.id)).toList());
  }

  @override
  Future<void> addNotification(AppNotificationModel model) async {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;
    await _col(uid).doc(model.id).set(model.toJson());
  }

  @override
  Future<void> markRead(Set<String> ids) async {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty || ids.isEmpty) return;
    final batch = firestore.batch();
    for (final id in ids) {
      final ref = _col(uid).doc(id);
      batch.update(ref, {
        'read': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  @override
  Future<void> deleteMy(String id) async {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;
    await _col(uid).doc(id).delete();
  }

  @override
  Future<void> sendTo(String toUid, AppNotificationModel model) async {
    if (toUid.isEmpty) return;
    await _col(toUid).add(model.toJson());
  }
}
