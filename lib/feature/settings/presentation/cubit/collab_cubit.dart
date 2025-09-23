import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/injection_container.dart';

class CollaboratorUser {
  CollaboratorUser({
    required this.uid,
    required this.email,
    required this.name,
  });
  final String uid;
  final String email;
  final String name;
}

class CollabState {
  const CollabState({
    this.loading = false,
    this.error,
    this.collaborators = const <CollaboratorUser>[],
    this.invites = const <CollabInvite>[],
  });

  final bool loading;
  final String? error;
  final List<CollaboratorUser> collaborators;
  final List<CollabInvite> invites;

  CollabState copyWith({
    bool? loading,
    String? error,
    List<CollaboratorUser>? collaborators,
    List<CollabInvite>? invites,
  }) => CollabState(
    loading: loading ?? this.loading,
    error: error,
    collaborators: collaborators ?? this.collaborators,
    invites: invites ?? this.invites,
  );
}

class CollabInvite {
  CollabInvite({
    required this.uid,
    required this.email,
    required this.status,
  }); // waiting | accepted | rejected

  factory CollabInvite.fromMap(Map<String, dynamic> map) => CollabInvite(
    uid: (map['uid'] as String?) ?? '',
    email: (map['email'] as String?) ?? '',
    status: (map['status'] as String?) ?? 'waiting',
  );
  final String uid;
  final String email;
  final String status;

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'status': status,
  };
}

class CollabCubit extends Cubit<CollabState> {
  CollabCubit(this._auth, this._firestore) : super(const CollabState());

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSub;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> loadCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    emit(state.copyWith(loading: true));
    try {
      final doc = await _firestore
          .collection(FirebasePaths.users)
          .doc(uid)
          .get();
      var collaboratorIds =
          (doc.data()?['collaborators'] as List?)?.cast<String>() ??
          const <String>[];
      if (collaboratorIds.length > 1) {
        collaboratorIds = [
          collaboratorIds.first,
        ]; // Tek partner kuralı: normalize et
      }
      final invitesRaw =
          (doc.data()?['collabInvites'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const <Map<String, dynamic>>[];
      final removedList =
          (doc.data()?['removedCollaborators'] as List?)?.cast<String>() ??
          const <String>[];
      final invites = invitesRaw.map(CollabInvite.fromMap).toList();
      // Remote acceptance detection: Eğer waiting davet var ve karşı taraf kendi belgesinde beni collaborator olarak eklediyse
      // (acceptor cross-write yetkisi olmadığı için benim dokümanım güncellenmemiş olabilir) burada self-heal yap.
      var inviterHealChanged = false;
      for (final inv in invites) {
        if (inv.status == 'waiting') {
          try {
            final otherSnap = await _firestore
                .collection(FirebasePaths.users)
                .doc(inv.uid)
                .get();
            final otherData = otherSnap.data();
            if (otherData != null) {
              final otherCollabs =
                  (otherData['collaborators'] as List?)?.cast<String>() ??
                  const <String>[];
              if (otherCollabs.contains(uid)) {
                // Karşı taraf beni eklemiş => kabul gerçekleşmiş, kendi doc'umu güncelle.
                if (!collaboratorIds.contains(inv.uid)) {
                  collaboratorIds = [inv.uid]; // tek partner kuralı
                }
                // Davet durumunu accepted'a terfi ettireceğiz (aşağıdaki normalize turunda)
                inviterHealChanged = true;
              }
            }
          } on Exception catch (e) {
            debugPrint('Remote acceptance check failed for ${inv.uid}: $e');
          }
        }
      }
      // Yeni mantık: collaborators listesine girmiş bir id fiilen kabul edilmiş sayılır.
      final healedIds = List<String>.from(collaboratorIds);
      // Persist normalization of invite statuses (accepted / removed) back to Firestore if needed
      var persistChanged =
          inviterHealChanged; // remote acceptance tetiklendiyse kesin yazacağız
      for (var i = 0; i < invites.length; i++) {
        final inv = invites[i];
        // Collaborators dizisine girmişse waiting -> accepted geçir
        if (healedIds.contains(inv.uid) && inv.status == 'waiting') {
          invites[i] = CollabInvite(
            uid: inv.uid,
            email: inv.email,
            status: 'accepted',
          );
          persistChanged = true;
        }
        // If explicitly removed but invite not marked -> mark removed
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
          // Tek partner kuralı: yalnızca ilkini yaz
          final single = healedIds.isEmpty
              ? <String>[]
              : <String>[healedIds.first];
          await _firestore.collection(FirebasePaths.users).doc(uid).set({
            'collabInvites': invites.map((e) => e.toMap()).toList(),
            'collaborators': single,
          }, SetOptions(merge: true));
        } on Exception catch (e) {
          debugPrint('Failed to persist normalized invite statuses: $e');
        }
        // Remote acceptance durumunda (inviterHealChanged) dowrylist (userItems) senkronizasyonunu tetikle.
        if (inviterHealChanged && healedIds.isNotEmpty) {
          final partnerUid = healedIds.first;
          try {
            await sl<UserService>().shareAllItemsWithPartner(partnerUid);
            await sl<UserService>().sharePartnerItemsWithMe(partnerUid);
            debugPrint(
              '[CollabCubit] Synced userItems with partner $partnerUid after remote acceptance',
            );
          } on Exception catch (e) {
            debugPrint(
              '[CollabCubit] Failed dowrylist sync on remote acceptance: $e',
            );
          }
        }
      }
      // fetch collaborator profiles
      final list = <CollaboratorUser>[];
      for (final id in healedIds) {
        try {
          final u = await _firestore
              .collection(FirebasePaths.users)
              .doc(id)
              .get();
          final data = u.data();
          if (data != null) {
            var email = (data['email'] as String?) ?? '';
            final name = (data['name'] as String?) ?? '';
            // Fallback: davet kaydındaki e-postayı kullan (özellikle eski kullanıcı profillerinde email/name eksikse)
            if (email.isEmpty) {
              for (final inv in invites) {
                if (inv.uid == id && inv.email.isNotEmpty) {
                  email = inv.email;
                  break;
                }
              }
            }
            list.add(
              CollaboratorUser(
                uid: id,
                email: email,
                name: name,
              ),
            );
          }
        } on Exception catch (e) {
          debugPrint('Failed to fetch collaborator $id: $e');
        }
      }
      emit(
        state.copyWith(loading: false, collaborators: list, invites: invites),
      );
    } on Exception catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> addByEmail(String email, {BuildContext? context}) async {
    final uid = _uid;
    if (uid == null) return;
    final norm = email.trim().toLowerCase();
    if (norm.isEmpty) return;
    emit(state.copyWith(loading: true));
    try {
      // Tek partner kuralı: eğer zaten partner varsa yeni davet oluşturma
      try {
        final snap = await _firestore
            .collection(FirebasePaths.users)
            .doc(uid)
            .get();
        final existing =
            (snap.data()?['collaborators'] as List?)?.cast<String>() ??
            const <String>[];
        if (existing.isNotEmpty) {
          emit(
            state.copyWith(
              loading: false,
              error:
                  context?.loc.alreadyHasPartnerError ??
                  'Zaten bir partneriniz var. Önce mevcut partneri kaldırın.',
            ),
          );
          return;
        }
      } on Exception {
        // ignore
      }
      // Rate limiting kaldırıldı: İstemci artık pencere başına davet sayısı ile kısıtlanmıyor.

      final q = await _firestore
          .collection(FirebasePaths.users)
          .where('email', isEqualTo: norm)
          .limit(1)
          .get();
      if (q.docs.isEmpty) {
        emit(
          state.copyWith(
            loading: false,
            error: context?.loc.userNotFoundError ?? 'Kullanıcı bulunamadı',
          ),
        );
        return;
      }
      final other = q.docs.first;
      final otherUid = other.id;
      if (otherUid == uid) {
        emit(
          state.copyWith(
            loading: false,
            error:
                context?.loc.cannotInviteSelfError ??
                'Kendinizi ekleyemezsiniz',
          ),
        );
        return;
      }
      // Check if the target user has purchased the collaborator feature
      try {
        final otherData = other.data();
        final premium =
            (otherData['premium'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};
        final otherCollabUnlocked =
            (premium['collabUnlocked'] as bool?) ?? false;
        if (!otherCollabUnlocked) {
          emit(
            state.copyWith(
              loading: false,
              error:
                  context?.loc.targetNotEntitledError ??
                  'Kullanıcı partner ekleme özelliğini satın almamış',
            ),
          );
          return;
        }
      } on Exception catch (_) {
        // If we can't read target profile, fail-safe: continue with existing flow (or optionally block)
      }
      // Eğer zaten aynı kullanıcıya ait waiting/accepted bir davet varsa tekrar oluşturma
      try {
        final selfSnap = await _firestore
            .collection(FirebasePaths.users)
            .doc(uid)
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
          emit(
            state.copyWith(
              loading: false,
              error:
                  context?.loc.inviteAlreadyPendingError ??
                  'Bu kullanıcıya zaten bekleyen bir davet var',
            ),
          );
          return;
        }
      } on Exception {
        // ignore
      }

      // Diğer kullanıcıya onaya düşecek bildirim gönder (title = daveti gönderen kullanıcının email'i)
      try {
        var inviterEmail = '';
        try {
          final inviterSnap = await _firestore
              .collection(FirebasePaths.users)
              .doc(uid)
              .get();
          inviterEmail =
              (inviterSnap.data()?['email'] as String?)?.trim().toLowerCase() ??
              '';
        } on Exception catch (_) {}
        inviterEmail = inviterEmail.isNotEmpty
            ? inviterEmail
            : (_auth.currentUser?.email?.toLowerCase() ?? '');
        if (inviterEmail.isEmpty) inviterEmail = 'Bir kullanıcı';
        final notifData = {
          'type': 'collab_request',
          'title': '$inviterEmail sizi ortak olarak davet etti',
          'body': '',
          'itemId': '',
          'category': '',
          'createdBy': uid, // isteği oluşturan kişi
          'createdAt': FieldValue.serverTimestamp(),
          'read': false,
        };
        debugPrint(
          '[CollabCubit] Sending collab_request notification to $otherUid data=$notifData',
        );
        await _firestore
            .collection(FirebasePaths.users)
            .doc(otherUid)
            .collection('notifications')
            .add(notifData);
        debugPrint('[CollabCubit] Notification write success to $otherUid');
      } on FirebaseException catch (e, st) {
        debugPrint(
          '[CollabCubit] Notification write failed for $otherUid code=${e.code} message=${e.message}\n$st',
        );
      } on Exception catch (e, st) {
        // bildirim gönderilemese de akışı bozma
        debugPrint(
          '[CollabCubit] Notification write failed for $otherUid (generic) $e\n$st',
        );
      }
      // Kendi kullanıcı dokümanında bekleyen daveti kaydet
      try {
        await _firestore.collection(FirebasePaths.users).doc(uid).set({
          'collabInvites': FieldValue.arrayUnion([
            CollabInvite(uid: otherUid, email: norm, status: 'waiting').toMap(),
          ]),
          // Eğer kullanıcı daha önce removedCollaborators listesine eklenmişse yeni davet ile birlikte o işareti kaldır.
          'removedCollaborators': FieldValue.arrayRemove([otherUid]),
        }, SetOptions(merge: true));
      } on Exception catch (_) {}
      // Sadece state'i yeniden yükle (waiting göstermek için)
      await loadCollaborators();
    } on Exception catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> remove(String otherUid, {BuildContext? context}) async {
    final uid = _uid;
    if (uid == null) return;
    emit(state.copyWith(loading: true));
    try {
      // Kendi tarafından kaldır ve not al
      await _firestore.collection(FirebasePaths.users).doc(uid).set({
        'collaborators': FieldValue.arrayRemove([otherUid]),
        'removedCollaborators': FieldValue.arrayUnion([otherUid]),
      }, SetOptions(merge: true));
      // Karşı tarafı da anında senkron şekilde kaldır (bildirime gerek kalmadan UI tutarlılığı)
      try {
        await _firestore.collection(FirebasePaths.users).doc(otherUid).set({
          'collaborators': FieldValue.arrayRemove([uid]),
          'removedCollaborators': FieldValue.arrayUnion([uid]),
        }, SetOptions(merge: true));
      } on Exception catch (e) {
        debugPrint('Symmetric remove failed: $e');
      }
      // Her iki tarafta da collabInvites içindeki ilgili waiting/accepted kayıtları temizle (yeniden heal olmasın)
      try {
        Future<void> clean(String targetUid, String removedUid) async {
          final ref = _firestore.collection(FirebasePaths.users).doc(targetUid);
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

        await Future.wait([
          clean(uid, otherUid),
          clean(otherUid, uid),
        ]);
      } on Exception catch (e) {
        debugPrint('Failed to clean invites after remove: $e');
      }
      // Karşı tarafa bildirim at; onlar da kendi tarafında kaldırır (simetrik etki)
      try {
        await _firestore
            .collection(FirebasePaths.users)
            .doc(otherUid)
            .collection('notifications')
            .add({
              'type': 'collab_removed',
              'title': context?.loc.partnerRemoved ?? 'Ortak kaldırıldı',
              'body': '',
              'itemId': '',
              'category': '',
              'createdBy': uid,
              'createdAt': FieldValue.serverTimestamp(),
              'read': false,
            });
      } on Exception catch (_) {}
      await loadCollaborators();
    } on Exception catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  /// Start observing current user's document for real-time updates so that
  /// UI reflects partner acceptance / removal instantly without manual refresh.
  void observe() {
    final uid = _uid;
    if (uid == null) return;
    _userSub?.cancel();
    _userSub = _firestore
        .collection(FirebasePaths.users)
        .doc(uid)
        .snapshots()
        .listen(
          (_) => loadCollaborators(),
          onError: (Object e, StackTrace _) =>
              debugPrint('Collaborator observe error: $e'),
        );
    // Initial load
    unawaited(loadCollaborators());
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    return super.close();
  }
}
