import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wedlist/feature/login/data/datasources/auth_remote_data_source.dart';
import 'package:wedlist/feature/login/data/models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          );
      final user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          throw FirebaseAuthException(
            code: 'email-not-verified',
            message:
                'E-posta adresiniz doğrulanmamış. Lütfen e-postanızı kontrol edin.',
          );
        }
        return UserModel(id: user.uid, email: user.email ?? '');
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Şifre yanlış.');
      } else if (e.code == 'email-not-verified') {
        throw Exception(
          'E-posta adresiniz doğrulanmamış. Lütfen e-postanızı kontrol edin.',
        );
      } else {
        throw Exception('Giriş sırasında bir hata oluştu: ${e.message}');
      }
    } catch (e) {
      throw Exception('Giriş sırasında bir hata oluştu: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return UserModel(id: user.uid, email: user.email ?? '');
    }
    return null;
  }

  // region: Apple Sign In helpers
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<UserModel?> signInWithApple() async {
    try {
      // Create a nonce to protect against replay attacks.
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request Apple ID credential.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );
      final user = userCredential.user;
      if (user != null) {
        // Build candidate name from Apple fullName info or fallback
        final appleFullName = [
          appleCredential.givenName,
          appleCredential.familyName,
        ].whereType<String>().join(' ').trim();
        final candidateName = appleFullName.isNotEmpty
            ? appleFullName
            : (user.displayName ?? user.email?.split('@').first);

        // Update FirebaseAuth displayName if missing
        if ((user.displayName == null || user.displayName!.isEmpty) &&
            candidateName != null &&
            candidateName.isNotEmpty) {
          await user.updateDisplayName(candidateName);
        }

        // Upsert Firestore users/{uid}.name if absent/empty
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final snap = await userRef.get();
        final currentName = snap.data()?['name'] as String?;
        if (currentName == null || currentName.trim().isEmpty) {
          if (candidateName != null && candidateName.isNotEmpty) {
            await userRef.set(
              {
                'name': candidateName,
                if (user.email != null) 'email': user.email,
              },
              SetOptions(merge: true),
            );
          }
        }

        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw Exception('İşlem iptal edildi.');
      }
      throw Exception('Apple ile giriş başarısız: ${e.message}');
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase hata: ${e.message}');
    } catch (e) {
      throw Exception('Apple ile giriş sırasında bir hata oluştu: $e');
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('İşlem iptal edildi.');
      }
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user != null) {
        // Determine a candidate display name
        final candidateName =
            user.displayName ??
            googleUser.displayName ??
            user.email?.split('@').first;

        // Update FirebaseAuth profile if missing
        if ((user.displayName == null || user.displayName!.isEmpty) &&
            candidateName != null &&
            candidateName.isNotEmpty) {
          await user.updateDisplayName(candidateName);
        }

        // Upsert Firestore users/{uid}
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final snap = await userRef.get();
        final current = snap.data() ?? <String, Object?>{};
        final currentName = current['name'] as String?;
        final data = <String, Object?>{
          if (current['email'] == null &&
              (user.email != null || googleUser.email.isNotEmpty))
            'email': user.email ?? googleUser.email,
        };
        if ((currentName == null || currentName.trim().isEmpty) &&
            candidateName != null &&
            candidateName.isNotEmpty) {
          data['name'] = candidateName;
        }
        if (current['avatarUrl'] == null && googleUser.photoUrl != null) {
          data['avatarUrl'] = googleUser.photoUrl;
        }
        if (data.isNotEmpty) {
          await userRef.set(data, SetOptions(merge: true));
        }

        return UserModel(id: user.uid, email: user.email ?? '');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception('Firebase hata: ${e.message}');
    } catch (e) {
      throw Exception('Google ile giriş sırasında bir hata oluştu: $e');
    }
  }
}
