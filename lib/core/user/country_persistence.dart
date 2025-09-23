import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountryPersistenceService {
  CountryPersistenceService(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> syncSelectedCountryIfAny() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    final sel = (prefs.getString('selected_country') ?? '').toUpperCase();
    if (sel.isEmpty) return;
    await _firestore.collection('users').doc(uid).set({'country': sel}, SetOptions(merge: true));
    // Clear local cache to avoid re-writing on next sessions
    await prefs.remove('selected_country');
  }

  Future<void> setCountry(String countryCode) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final code = countryCode.toUpperCase();
    await _firestore.collection('users').doc(uid).set({'country': code}, SetOptions(merge: true));
  }
}
