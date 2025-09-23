import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';
import 'package:wedlist/feature/register/data/datasources/register_remote_data_source.dart';
import 'package:wedlist/feature/register/data/models/register_model.dart';

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  @override
  Future<void> register(RegisterModel model) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: model.email,
            password: model.password,
          );
      // Send verification email immediately after account creation
      await userCredential.user?.sendEmailVerification();
      final uid = userCredential.user?.uid;
      if (uid != null) {
        String? avatarUrl;
        if (model.avatarBytes != null) {
          final path = 'users/$uid/profile/avatar.jpg';
          final ref = FirebaseStorage.instance.ref(path);
          await ref.putData(model.avatarBytes!);
          avatarUrl = await ref.getDownloadURL();
        }
        final userRef = FirebaseFirestore.instance
            .collection(FirebasePaths.users)
            .doc(uid);
        await userRef.set({
          'uid': uid,
          'email': model.email.trim().toLowerCase(),
          'name': model.name,
          if (model.weddingDate != null)
            'weddingDate': Timestamp.fromDate(model.weddingDate!),
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Persist selected country to user profile so it roams across devices
        final prefs = await SharedPreferences.getInstance();
        var country = (prefs.getString('selected_country') ?? '').toUpperCase();
        if (country.isEmpty) {
          country = (ui.PlatformDispatcher.instance.locale.countryCode ?? 'TR')
              .toUpperCase();
        }
        await userRef.set({'country': country}, SetOptions(merge: true));
        await prefs.remove('selected_country');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Bu e-posta adresi zaten kayıtlı.');
      } else {
        throw Exception('Kayıt sırasında bir hata oluştu: ${e.message}');
      }
    }
  }
}
