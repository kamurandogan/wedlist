import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
// import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/feature/settings/domain/entities/collab.dart';
import 'package:wedlist/feature/settings/domain/usecases/add_collab_invite.dart';
import 'package:wedlist/feature/settings/domain/usecases/load_collab_summary.dart';
import 'package:wedlist/feature/settings/domain/usecases/remove_partner.dart';

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

class CollabCubit extends Cubit<CollabState> {
  CollabCubit(
    this._auth,
    this._firestore,
    this._load,
    this._addInvite,
    this._removePartner,
  ) : super(const CollabState());

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final LoadCollabSummary _load;
  final AddCollabInvite _addInvite;
  final RemovePartner _removePartner;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSub;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> loadCollaborators() async {
    final uid = _uid;
    if (uid == null) return;
    emit(state.copyWith(loading: true));
    try {
      final summary = await _load(uid);
      emit(
        state.copyWith(
          loading: false,
          collaborators: summary.collaborators,
          invites: summary.invites,
        ),
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
      await _addInvite(meUid: uid, email: norm);
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
      await _removePartner(meUid: uid, otherUid: otherUid);
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
        .collection('users')
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
