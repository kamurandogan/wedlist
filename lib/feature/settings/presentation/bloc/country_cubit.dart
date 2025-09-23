import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/settings/domain/usecases/change_country.dart';
import 'package:wedlist/feature/settings/domain/usecases/watch_country.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  CountryCubit(this._watch, this._change, this._firestore, this._auth, this._refreshBus) : super(const CountryState()) {
    _sub = _watch().listen((value) {
      emit(state.copyWith(countryCode: value, status: CountryStatus.ready));
    });
  }

  final WatchCountry _watch;
  final ChangeCountry _change;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final RefreshBus _refreshBus;
  StreamSubscription<String?>? _sub;

  Future<void> change(String code) async {
    final prev = state.countryCode;
    if (prev != null && prev.toUpperCase() == code.toUpperCase()) {
      return; // no change
    }
    emit(state.copyWith(status: CountryStatus.updating));
    try {
      await _change(code);
      await _resetWishList();
      // Publish global refresh event so other blocs can respond
      _refreshBus.countryChanged();
      emit(state.copyWith(status: CountryStatus.ready, lastMessage: 'updated', wishlistInvalidated: true));
    } on Exception catch (e) {
      emit(state.copyWith(status: CountryStatus.error, lastMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<void> _resetWishList() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final ref = _firestore.collection('users').doc(uid);
    await ref.set({'wishList': <Map<String, dynamic>>[]}, SetOptions(merge: true));
  }
}
