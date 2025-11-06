import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Removed direct localization dependency; bloc emits neutral keys.
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';
import 'package:wedlist/feature/notification/domain/usecases/delete_notification.dart';
import 'package:wedlist/feature/notification/domain/usecases/mark_notifications_read.dart';
import 'package:wedlist/feature/notification/domain/usecases/send_notification_to_user.dart';
import 'package:wedlist/feature/notification/domain/usecases/watch_notifications.dart';
import 'package:wedlist/injection_container.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(
    this.watch,
    this.markRead,
    this.deleteNotification,
    this.sendToUser,
  ) : super(NotificationInitial()) {
    on<SubscribeNotifications>(_onSubscribe);
    on<_NotificationsUpdated>(_onNotificationsUpdated);
    on<_NotificationsError>(
      (event, emit) => emit(NotificationError(event.message)),
    );
    on<MarkAllRead>(_onMarkAllRead);
    on<AcceptCollab>(_onAcceptCollab);
    on<RejectCollab>(_onRejectCollab);
    on<HandleCollabRemoved>(_onHandleCollabRemoved);
  }
  final WatchNotifications watch;
  final MarkNotificationsRead markRead;
  final DeleteNotificationUseCase deleteNotification;
  final SendNotificationToUser sendToUser;
  StreamSubscription<List<AppNotificationEntity>>? _sub;

  // Passive-side otomatik senkronizasyon: collab_accepted bildirimi gelince hemen item & wishList senkronize et.
  Future<void> _onNotificationsUpdated(
    _NotificationsUpdated event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoaded(event.items));
    try {
      // In unit tests, Firebase.initializeApp() may not be called; guard accordingly.
      String? uid;
      try {
        uid = FirebaseAuth.instance.currentUser?.uid;
      } on Exception {
        // No Firebase app in test env; skip passive sync.
        return;
      }
      if (uid == null) return;
      // Bir veya daha fazla collab_accepted bildirimi varsa partner UIDs setini çıkar.
      final accepted = event.items
          .where((n) => n.type == AppNotificationType.collabAccepted)
          .toList();
      if (accepted.isEmpty) return;
      // processedAccepted seti ile aynı bildirimi tekrar tekrar tetiklemeyi engelle.
      // (In-memory; app restart olursa tekrar çalışır — idempotent olduğu için güvenli.)
      accepted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final latest =
          accepted.first; // Tek partner kuralı olduğundan son kabul yeterli.
      final partnerUid = latest.createdBy; // createdBy = kabul eden
      if (partnerUid.isEmpty) return;
      // Senkronizasyon çağrıları idempotent.
      // Only update my items to include partner (allowed by rules). Partner's client will run its own sync.
      await sl<UserService>().shareAllItemsWithPartner(partnerUid);
      await sl<UserService>().importPartnerWishListOnce(partnerUid);
      // Do NOT write to partner's users doc from this client (forbidden by rules)
      await sl<UserService>().ensureUserItemsSymmetric();
    } on Exception catch (e) {
      debugPrint(
        '[NotificationBloc] Passive sync on collab_accepted failed: $e',
      );
    }
  }

  Future<void> _onSubscribe(
    SubscribeNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    await _sub?.cancel();
    emit(NotificationLoading());
    _sub = watch().listen(
      (list) => add(_NotificationsUpdated(list)),
      onError: (Object e, StackTrace _) =>
          add(_NotificationsError(e.toString())),
    );
  }

  Future<void> _onMarkAllRead(
    MarkAllRead event,
    Emitter<NotificationState> emit,
  ) async {
    if (event.ids.isEmpty) return;
    try {
      await markRead(event.ids);
    } on Exception catch (_) {
      // best-effort, keep stream driving UI
    }
  }

  Future<void> _onAcceptCollab(
    AcceptCollab event,
    Emitter<NotificationState> emit,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || event.senderUid.isEmpty) return;
    try {
      // Tek partner kuralı: sadece birbirini partner olarak ayarla.
      await sl<UserService>().setSinglePartner(event.senderUid);
    } on Exception catch (_) {}
    try {
      // Karşılıklı paylaşım: userItems ve wishList union (idempotent).
      await sl<UserService>().shareAllItemsWithPartner(event.senderUid);
      await sl<UserService>().sharePartnerItemsWithMe(event.senderUid);
      await sl<UserService>().importPartnerWishListOnce(event.senderUid);
      await sl<UserService>().importSelfWishListInto(event.senderUid);
      // Ek: geçmiş (eski) item'lar için çift taraflı sahip listesi şifasını iyileştir.
      await sl<UserService>().ensureUserItemsSymmetric();
    } on Exception catch (_) {}
    // Daveti gönderen kullanıcının (inviter) collabInvites içindeki ilgili kaydı 'accepted' olarak işaretle
    try {
      final inviterRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.senderUid);
      final inviterSnap = await inviterRef.get();
      final inviterData = inviterSnap.data() ?? <String, dynamic>{};
      final rawInvites =
          (inviterData['collabInvites'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const <Map<String, dynamic>>[];
      var changed = false;
      final updated = <Map<String, dynamic>>[];
      for (final inv in rawInvites) {
        final invUid = (inv['uid'] as String?) ?? '';
        if (invUid == uid) {
          final newMap = Map<String, dynamic>.from(inv)
            ..['status'] = 'accepted';
          updated.add(newMap);
          changed = true;
        } else {
          updated.add(inv);
        }
      }
      if (changed) {
        await inviterRef.set({
          'collabInvites': updated,
        }, SetOptions(merge: true));
      }
    } on Exception catch (_) {}
    // Kabul eden kullanıcının (acceptor) kendi collabInvites listesini de normalize et (varsa)
    try {
      final acceptorRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid);
      final acceptorSnap = await acceptorRef.get();
      final acceptorData = acceptorSnap.data() ?? <String, dynamic>{};
      final rawInvites =
          (acceptorData['collabInvites'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const <Map<String, dynamic>>[];
      if (rawInvites.isNotEmpty) {
        var changed = false;
        final updated = <Map<String, dynamic>>[];
        for (final inv in rawInvites) {
          final invUid = (inv['uid'] as String?) ?? '';
          // Eğer bu davet kabul edilen kullanıcıya aitse status'u 'accepted' yap
          if (invUid == event.senderUid) {
            final newMap = Map<String, dynamic>.from(inv)
              ..['status'] = 'accepted';
            updated.add(newMap);
            changed = true;
          } else {
            // Tek partner kuralı: farklı waiting davetleri (henüz accepted olmayan) istersen kaldırabilir ya da 'removed' işaretleyebiliriz.
            // Şimdilik sadece bırakıyoruz ama waiting kalmasını istemiyorsak burada status değiştirilebilir.
            updated.add(inv);
          }
        }
        if (changed) {
          await acceptorRef.set({
            'collabInvites': updated,
          }, SetOptions(merge: true));
        }
      }
    } on Exception catch (_) {}
    try {
      await deleteNotification(event.notifId);
    } on Exception catch (_) {}
    try {
      await sendToUser(
        event.senderUid,
        AppNotificationEntity(
          id: '',
          type: AppNotificationType.collabAccepted,
          // Use a neutral key; UI will localize based on type
          title: 'COLLAB_ACCEPTED',
          body: '',
          itemId: '',
          category: '',
          createdBy: uid,
          createdAt: DateTime.now(),
          read: false,
        ),
      );
    } on Exception catch (_) {}
  }

  Future<void> _onRejectCollab(
    RejectCollab event,
    Emitter<NotificationState> emit,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Daveti gönderen kullanıcının (inviter) collabInvites içindeki kaydı 'rejected' olarak işaretle
    try {
      final inviterRef = FirebaseFirestore.instance
          .collection('users')
          .doc(event.senderUid);
      final inviterSnap = await inviterRef.get();
      final inviterData = inviterSnap.data() ?? <String, dynamic>{};
      final rawInvites =
          (inviterData['collabInvites'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const <Map<String, dynamic>>[];
      var changed = false;
      final updated = <Map<String, dynamic>>[];
      for (final inv in rawInvites) {
        final invUid = (inv['uid'] as String?) ?? '';
        if (invUid == uid) {
          // Rejector'un invite'ını rejected yap
          final newMap = Map<String, dynamic>.from(inv)
            ..['status'] = 'rejected';
          updated.add(newMap);
          changed = true;
        } else {
          updated.add(inv);
        }
      }
      if (changed) {
        await inviterRef.set({
          'collabInvites': updated,
        }, SetOptions(merge: true));
      }
    } on Exception catch (_) {}

    // Reddeden kullanıcının (rejector) kendi collabInvites listesini de güncelle (varsa)
    try {
      final rejectorRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid);
      final rejectorSnap = await rejectorRef.get();
      final rejectorData = rejectorSnap.data() ?? <String, dynamic>{};
      final rawInvites =
          (rejectorData['collabInvites'] as List?)
              ?.cast<Map<String, dynamic>>() ??
          const <Map<String, dynamic>>[];
      if (rawInvites.isNotEmpty) {
        var changed = false;
        final updated = <Map<String, dynamic>>[];
        for (final inv in rawInvites) {
          final invUid = (inv['uid'] as String?) ?? '';
          if (invUid == event.senderUid) {
            final newMap = Map<String, dynamic>.from(inv)
              ..['status'] = 'rejected';
            updated.add(newMap);
            changed = true;
          } else {
            updated.add(inv);
          }
        }
        if (changed) {
          await rejectorRef.set({
            'collabInvites': updated,
          }, SetOptions(merge: true));
        }
      }
    } on Exception catch (_) {}

    try {
      await deleteNotification(event.notifId);
    } on Exception catch (_) {}
    try {
      await sendToUser(
        event.senderUid,
        AppNotificationEntity(
          id: '',
          type: AppNotificationType.collabRejected,
          title: 'COLLAB_REJECTED',
          body: '',
          itemId: '',
          category: '',
          createdBy: uid,
          createdAt: DateTime.now(),
          read: false,
        ),
      );
    } on Exception catch (_) {}
  }

  Future<void> _onHandleCollabRemoved(
    HandleCollabRemoved event,
    Emitter<NotificationState> emit,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || event.removerUid.isEmpty) return;
    final fs = FirebaseFirestore.instance;
    try {
      await fs.collection('users').doc(uid).set({
        'collaborators': FieldValue.arrayRemove([event.removerUid]),
        'removedCollaborators': FieldValue.arrayUnion([event.removerUid]),
      }, SetOptions(merge: true));
    } on Exception catch (_) {}
    try {
      await deleteNotification(event.notifId);
    } on Exception catch (_) {}
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
