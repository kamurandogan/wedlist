import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/user/country_persistence.dart' as core_service;
import 'package:wedlist/feature/settings/domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  CountryRepositoryImpl(this._firestore, this._auth, this._service);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final core_service.CountryPersistenceService _service;

  @override
  Stream<String?> watchCountry() async* {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      yield null;
      return;
    }
    yield* _firestore.collection('users').doc(uid).snapshots().map((s) {
      return (s.data()?['country'] as String?)?.toUpperCase();
    });
  }

  @override
  Future<void> changeCountry(String code) => _service.setCountry(code);
}
