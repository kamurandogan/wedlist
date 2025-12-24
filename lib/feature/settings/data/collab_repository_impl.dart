import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/feature/settings/domain/entities/collab.dart';
import 'package:wedlist/feature/settings/domain/repositories/collab_repository.dart';
import 'package:wedlist/injection_container.dart';

class CollabRepositoryImpl implements CollabRepository {
  CollabRepositoryImpl(this.fs, this.auth);
  final FirebaseFirestore fs;
  final FirebaseAuth auth;

  @override
  Future<CollabSummary> load(String uid) async {
    final doc = await fs.collection(FirebasePaths.users).doc(uid).get();
    var collaboratorIds =
        (doc.data()?['collaborators'] as List?)?.cast<String>() ??
        const <String>[];
    if (collaboratorIds.length > 1) {
      collaboratorIds = [collaboratorIds.first];
    }
    final invitesRaw =
        (doc.data()?['collabInvites'] as List?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];
    final removedList =
        (doc.data()?['removedCollaborators'] as List?)?.cast<String>() ??
        const <String>[];
    final invites = invitesRaw.map(CollabInvite.fromMap).toList();

    // Remote acceptance heal
    var inviterHealChanged = false;
    for (final inv in invites) {
      if (inv.status == 'waiting') {
        try {
          final otherSnap = await fs
              .collection(FirebasePaths.users)
              .doc(inv.uid)
              .get();
          final otherData = otherSnap.data();
          if (otherData != null) {
            final otherCollabs =
                (otherData['collaborators'] as List?)?.cast<String>() ??
                const <String>[];
            if (otherCollabs.contains(uid)) {
              if (!collaboratorIds.contains(inv.uid)) {
                collaboratorIds = [inv.uid];
              }
              inviterHealChanged = true;
            }
          }
        } on Exception catch (e) {
          debugPrint('Remote acceptance check failed for ${inv.uid}: $e');
        }
      }
    }

    final healedIds = List<String>.from(collaboratorIds);
    var persistChanged = inviterHealChanged;
    for (var i = 0; i < invites.length; i++) {
      final inv = invites[i];
      if (healedIds.contains(inv.uid) && inv.status == 'waiting') {
        invites[i] = CollabInvite(
          uid: inv.uid,
          email: inv.email,
          status: 'accepted',
        );
        persistChanged = true;
      }
      if (removedList.contains(inv.uid) && inv.status != 'removed') {
        invites[i] = CollabInvite(
          uid: inv.uid,
          email: inv.email,
          status: 'removed',
        );
        persistChanged = true;
      }
    }

    if (persistChanged) {
      try {
        final single = healedIds.isEmpty
            ? <String>[]
            : <String>[healedIds.first];
        await fs.collection(FirebasePaths.users).doc(uid).set({
          'collabInvites': invites.map((e) => e.toMap()).toList(),
          'collaborators': single,
        }, SetOptions(merge: true));
      } on Exception catch (e) {
        debugPrint('Failed to persist normalized invite statuses: $e');
      }
      if (inviterHealChanged && healedIds.isNotEmpty) {
        final partnerUid = healedIds.first;
        try {
          await sl<UserService>().shareAllItemsWithPartner(partnerUid);
          await sl<UserService>().sharePartnerItemsWithMe(partnerUid);
          debugPrint(
            '[CollabRepo] Synced items with partner $partnerUid after remote acceptance',
          );
        } on Exception catch (e) {
          debugPrint('[CollabRepo] Failed sync on remote acceptance: $e');
        }
      }
    }

    final list = <CollaboratorUser>[];
    for (final id in healedIds) {
      try {
        final u = await fs.collection(FirebasePaths.users).doc(id).get();
        final data = u.data();
        if (data != null) {
          var email = (data['email'] as String?) ?? '';
          final name = (data['name'] as String?) ?? '';
          if (email.isEmpty) {
            for (final inv in invites) {
              if (inv.uid == id && inv.email.isNotEmpty) {
                email = inv.email;
                break;
              }
            }
          }
          list.add(CollaboratorUser(uid: id, email: email, name: name));
        }
      } on Exception catch (e) {
        debugPrint('Failed to fetch collaborator $id: $e');
      }
    }

    return CollabSummary(collaborators: list, invites: invites);
  }

  @override
  Future<void> addInvite({required String meUid, required String email}) async {
    final norm = email.trim().toLowerCase();
    if (norm.isEmpty) return;

    // Email format validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(norm)) {
      throw Exception('invalid_email_format');
    }

    // partner var mı? engelle
    try {
      final snap = await fs.collection(FirebasePaths.users).doc(meUid).get();
      final existing =
          (snap.data()?['collaborators'] as List?)?.cast<String>() ??
          const <String>[];
      if (existing.isNotEmpty) {
        throw Exception('already_has_partner');
      }
    } on Exception {
      /* ignore */
    }

    // hedef kullanıcıyı bul
    final q = await fs
        .collection(FirebasePaths.users)
        .where('email', isEqualTo: norm)
        .limit(1)
        .get();
    if (q.docs.isEmpty) {
      throw Exception('user_not_found');
    }
    final other = q.docs.first;
    final otherUid = other.id;
    if (otherUid == meUid) {
      throw Exception('cannot_invite_self');
    }

    // aynı bekleyen davet var mı
    try {
      final selfSnap = await fs
          .collection(FirebasePaths.users)
          .doc(meUid)
          .get();
      final existingInvites =
          (selfSnap.data()?['collabInvites'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const <Map<String, dynamic>>[];
      final already = existingInvites.any(
        (m) =>
            (m['uid'] as String?) == otherUid &&
            ((m['status'] as String?) ?? 'waiting') == 'waiting',
      );
      if (already) {
        throw Exception('invite_already_pending');
      }
    } on Exception {
      /* ignore */
    }

    // Davet eden kişinin email'ini al
    var inviterEmail = '';
    try {
      final inviterSnap = await fs
          .collection(FirebasePaths.users)
          .doc(meUid)
          .get();
      inviterEmail =
          (inviterSnap.data()?['email'] as String?)?.trim().toLowerCase() ?? '';
    } on Exception {
      /* ignore */
    }
    inviterEmail = inviterEmail.isNotEmpty
        ? inviterEmail
        : (auth.currentUser?.email?.toLowerCase() ?? '');
    if (inviterEmail.isEmpty) inviterEmail = 'Bir kullanıcı';

    // bildirim gönder (best-effort)
    try {
      await fs
          .collection(FirebasePaths.users)
          .doc(otherUid)
          .collection('notifications')
          .add({
            'type': 'collab_request',
            'title': '$inviterEmail sizi ortak olarak davet etti',
            'body': '',
            'itemId': '',
            'category': '',
            'createdBy': meUid,
            'createdAt': FieldValue.serverTimestamp(),
            'read': false,
          });
    } on Exception catch (e) {
      debugPrint('[CollabRepo] Notification write failed: $e');
    }

    // hedef kullanıcının email'ini al (A kullanıcısı B'nin collabInvites'ında kendi bilgisini görmek için)
    var targetEmail = '';
    try {
      final targetSnap = await fs
          .collection(FirebasePaths.users)
          .doc(otherUid)
          .get();
      targetEmail =
          (targetSnap.data()?['email'] as String?)?.trim().toLowerCase() ?? '';
    } on Exception {
      /* ignore */
    }
    targetEmail = targetEmail.isNotEmpty ? targetEmail : norm;

    // bekleyen daveti HER İKİ kullanıcıya kaydet
    // B kullanıcısı: A'dan gelen daveti görür (uid: meUid)
    // A kullanıcısı: B'ye gönderdiği daveti görür (uid: otherUid)
    await Future.wait([
      // Hedef kullanıcıya (B) daveti kaydet - kimden geldiğini gösterir
      fs.collection(FirebasePaths.users).doc(otherUid).set({
        'collabInvites': FieldValue.arrayUnion([
          CollabInvite(
            uid: meUid,
            email: inviterEmail,
            status: 'waiting',
          ).toMap(),
        ]),
        'removedCollaborators': FieldValue.arrayRemove([meUid]),
      }, SetOptions(merge: true)),
      // Davet eden kullanıcıya (A) daveti kaydet - kime gönderdiğini gösterir
      fs.collection(FirebasePaths.users).doc(meUid).set({
        'collabInvites': FieldValue.arrayUnion([
          CollabInvite(
            uid: otherUid,
            email: targetEmail,
            status: 'waiting',
          ).toMap(),
        ]),
        'removedCollaborators': FieldValue.arrayRemove([otherUid]),
      }, SetOptions(merge: true)),
    ]);
  }

  @override
  Future<void> removePartner({
    required String meUid,
    required String otherUid,
  }) async {
    // kendi tarafından kaldır ve işaretle
    await fs.collection(FirebasePaths.users).doc(meUid).set({
      'collaborators': FieldValue.arrayRemove([otherUid]),
      'removedCollaborators': FieldValue.arrayUnion([otherUid]),
    }, SetOptions(merge: true));

    // karşı tarafı simetrik kaldır (best-effort)
    try {
      await fs.collection(FirebasePaths.users).doc(otherUid).set({
        'collaborators': FieldValue.arrayRemove([meUid]),
        'removedCollaborators': FieldValue.arrayUnion([meUid]),
      }, SetOptions(merge: true));
    } on Exception {
      /* ignore */
    }

    // KRITIK: Tüm item'lardan partneri kaldır (güvenlik için)
    try {
      // Kendi item'larımdan partneri kaldır
      final myItems = await fs
          .collection('userItems')
          .where('owners', arrayContains: meUid)
          .get();

      // Batch işlemi ile 500'er item'lık gruplara böl
      final chunks = <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
      for (var i = 0; i < myItems.docs.length; i += 500) {
        final end = (i + 500 < myItems.docs.length)
            ? i + 500
            : myItems.docs.length;
        chunks.add(myItems.docs.sublist(i, end));
      }

      for (final chunk in chunks) {
        final batch = fs.batch();
        for (final doc in chunk) {
          final owners = (doc.data()['owners'] as List?)?.cast<String>() ?? [];
          if (owners.contains(otherUid)) {
            batch.update(doc.reference, {
              'owners': FieldValue.arrayRemove([otherUid]),
            });
          }
        }
        await batch.commit();
      }

      // Partner'ın item'larından da kendimi kaldır
      final partnerItems = await fs
          .collection('userItems')
          .where('owners', arrayContains: otherUid)
          .get();

      final partnerChunks =
          <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
      for (var i = 0; i < partnerItems.docs.length; i += 500) {
        final end = (i + 500 < partnerItems.docs.length)
            ? i + 500
            : partnerItems.docs.length;
        partnerChunks.add(partnerItems.docs.sublist(i, end));
      }

      for (final chunk in partnerChunks) {
        final batch = fs.batch();
        for (final doc in chunk) {
          final owners = (doc.data()['owners'] as List?)?.cast<String>() ?? [];
          if (owners.contains(meUid)) {
            batch.update(doc.reference, {
              'owners': FieldValue.arrayRemove([meUid]),
            });
          }
        }
        await batch.commit();
      }
    } on Exception catch (e) {
      debugPrint('[CollabRepo] Failed to remove partner from items: $e');
    }

    // her iki tarafta davet kayıtlarını temizle (best-effort)
    Future<void> clean(String targetUid, String removedUid) async {
      final ref = fs.collection(FirebasePaths.users).doc(targetUid);
      final snap = await ref.get();
      final raw =
          (snap.data()?['collabInvites'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const <Map<String, dynamic>>[];
      if (raw.isEmpty) return;
      final filtered = raw
          .where((m) => (m['uid'] as String?) != removedUid)
          .toList();
      if (filtered.length != raw.length) {
        await ref.set({'collabInvites': filtered}, SetOptions(merge: true));
      }
    }

    try {
      await Future.wait([
        clean(meUid, otherUid),
        clean(otherUid, meUid),
      ]);
    } on Exception {
      /* ignore */
    }

    // karşı tarafa bildirim gönder (best-effort)
    try {
      await fs
          .collection(FirebasePaths.users)
          .doc(otherUid)
          .collection('notifications')
          .add({
            'type': 'collab_removed',
            'title': 'Ortak kaldırıldı',
            'body': '',
            'itemId': '',
            'category': '',
            'createdBy': meUid,
            'createdAt': FieldValue.serverTimestamp(),
            'read': false,
          });
    } on Exception {
      /* ignore */
    }
  }
}
