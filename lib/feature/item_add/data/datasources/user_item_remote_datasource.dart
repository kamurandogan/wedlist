import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';
// NOTE: Do not import UI localization here; data layer should remain UI-agnostic.
import 'package:wedlist/feature/item_add/data/models/user_item_model.dart';

abstract class UserItemRemoteDataSource {
  Future<void> addUserItem(UserItemModel item);
  Future<UserItemModel?> fetchUserItemById(String id);
  Future<List<UserItemModel>> fetchAllUserItems();
  Future<void> updateUserItem(UserItemModel item);
  Future<void> deleteUserItem(String id);
  Stream<List<UserItemModel>> watchAllUserItems();
}

class UserItemRemoteDataSourceImpl implements UserItemRemoteDataSource {
  UserItemRemoteDataSourceImpl(this.firestore, this.storage, this.auth);
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseAuth auth;
  final String collectionPath = FirebasePaths.userItems;

  @override
  Future<void> addUserItem(UserItemModel item) async {
    final uid = auth.currentUser?.uid;
    final now = DateTime.now();
    var toSave = item;
    if (toSave.createdAt == null) {
      toSave = toSave.copyWith(createdAt: now);
    }
    var owners = const <String>[];
    if (uid != null) {
      try {
        final userDoc = await firestore
            .collection(FirebasePaths.users)
            .doc(uid)
            .get();
        final collabs = (userDoc.data()?['collaborators'] as List?)?.cast<String>() ?? const <String>[];
        final removed =
      (userDoc.data()?['removedCollaborators'] as List?)?.cast<String>() ?? const <String>[];
        owners = <String>{uid, ...collabs}.toList();
        toSave = toSave.copyWith(owners: owners, createdBy: uid);

        // Heal asymmetry: if I have no collaborators (or missing partner), but other users already list me,
        // include them so item sahipliği iki yönde görünür.
        try {
          final reverseQ = await firestore
              .collection(FirebasePaths.users)
              .where('collaborators', arrayContains: uid)
              .get();
          for (final d in reverseQ.docs) {
            final otherId = d.id;
            if (otherId == uid) continue;
            if (removed.contains(otherId)) {
              continue; // user explicitly removed them
            }
            if (!owners.contains(otherId)) {
              owners.add(otherId);
            }
          }
          if (owners.length != toSave.owners.length) {
            toSave = toSave.copyWith(owners: owners);
          }
        } on Exception {
          // best effort
        }
      } on Exception {
        // fallback to single owner if user doc missing
        owners = [uid];
        toSave = toSave.copyWith(owners: owners, createdBy: uid);
      }
    }
    await firestore
        .collection(collectionPath)
        .doc(toSave.id)
        .set(toSave.toJson());

    // Notify collaborators (all owners except the creator) about the new item
    try {
      if (uid != null && owners.isNotEmpty) {
        final recipients = owners.where((o) => o != uid).toList();
        if (recipients.isNotEmpty) {
          // optional extra safety: confirm these recipients still list uid as collaborator (best-effort)
          final verified = <String>[];
          for (final rid in recipients) {
            try {
              final rs = await firestore
                  .collection(FirebasePaths.users)
                  .doc(rid)
                  .get();
              final collabs =
                  (rs.data()?['collaborators'] as List?)?.cast<String>() ??
                  const <String>[];
              if (collabs.contains(uid)) {
                verified.add(rid);
              } else {
                verified.add(rid); // fallback keep
              }
            } on Exception {
              verified.add(rid);
            }
          }
          final payload = <String, dynamic>{
            'type': 'item_added',
            'title': toSave.title,
            // UI will localize 'item_added' type; keep a neutral body or key.
            'body': 'ITEM_ADDED',
            'itemId': toSave.id,
            'category': toSave.category,
            'createdBy': uid,
            'createdAt': FieldValue.serverTimestamp(),
            'read': false,
          };
          await Future.wait(
            verified.map(
              (rid) {
                debugPrint(
                  '[UserItemRemoteDataSource] Sending item_added notif to $rid for item ${toSave.id}',
                );
                return firestore
                    .collection(FirebasePaths.users)
                    .doc(rid)
                    .collection('notifications')
                    .add(payload);
              },
            ),
          );
        }
      }
    } on Exception catch (e, st) {
      debugPrint(
        '[UserItemRemoteDataSource] item_added notification failed: $e\n$st',
      );
    }
  }

  @override
  Future<UserItemModel?> fetchUserItemById(String id) async {
    final doc = await firestore.collection(collectionPath).doc(id).get();
    if (!doc.exists) return null;
    return UserItemModel.fromJson(doc.data()!);
  }

  @override
  Future<List<UserItemModel>> fetchAllUserItems() async {
    final uid = auth.currentUser?.uid;
    final col = firestore.collection(collectionPath);
    final snapshot = uid != null
        ? await col.where('owners', arrayContains: uid).get()
        : await col.get();
    return snapshot.docs
        .map((doc) => UserItemModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> updateUserItem(UserItemModel item) async {
    await firestore
        .collection(collectionPath)
        .doc(item.id)
        .update(item.toJson());
  }

  @override
  Future<void> deleteUserItem(String id) async {
    final docRef = firestore.collection(collectionPath).doc(id);
    final doc = await docRef.get();
    if (doc.exists) {
      try {
        final data = doc.data();
        final imgUrl = data?['imgUrl'] as String?;
        final owners =
            (data?['owners'] as List?)?.cast<String>() ?? const <String>[];
        final title = data?['title'] as String? ?? '';
        final category = data?['category'] as String? ?? '';
        if (imgUrl != null && imgUrl.isNotEmpty) {
          // Best-effort delete of the file from Firebase Storage
          try {
            final ref = storage.refFromURL(imgUrl);
            await ref.delete();
          } on Exception {
            // Ignore storage delete failures to not block item deletion
          }
        }
        // Bildirim (item_deleted) - sahibi haricindeki tüm sahipler
        try {
          final uid = auth.currentUser?.uid;
          if (uid != null && owners.isNotEmpty) {
            final recipients = owners.where((o) => o != uid).toList();
            if (recipients.isNotEmpty) {
              final payload = <String, dynamic>{
                'type': 'item_deleted',
                'title': title,
                'body': 'ITEM_DELETED',
                'itemId': id,
                'category': category,
                'createdBy': uid,
                'createdAt': FieldValue.serverTimestamp(),
                'read': false,
              };
              await Future.wait(
                recipients.map(
                  (rid) {
                    debugPrint(
                      '[UserItemRemoteDataSource] Sending item_deleted notif to $rid for item $id',
                    );
                    return firestore
                        .collection(FirebasePaths.users)
                        .doc(rid)
                        .collection('notifications')
                        .add(payload);
                  },
                ),
              );
            }
          }
        } on Exception catch (e, st) {
          debugPrint(
            '[UserItemRemoteDataSource] item_deleted notification failed: $e\n$st',
          );
        }
      } on Exception {
        // Ignore parsing errors and proceed to delete the doc
      }
    }
    await docRef.delete();
  }

  @override
  Stream<List<UserItemModel>> watchAllUserItems() {
    final uid = auth.currentUser?.uid;
    final col = firestore.collection(collectionPath);
    final query = uid != null ? col.where('owners', arrayContains: uid) : col;
    return query.snapshots().map(
      (snap) => snap.docs.map((d) => UserItemModel.fromJson(d.data())).toList(),
    );
  }
}
