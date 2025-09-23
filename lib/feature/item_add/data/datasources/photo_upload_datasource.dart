import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';

/// Data Source sözleşmesi: Firebase Storage'a bayt yükler ve indirme URL'sini döner.
abstract class PhotoUploadDataSource {
  Future<String> uploadBytes(
    Uint8List bytes,
    String fileName, {
    String? contentType,
    String directory = FirebasePaths.userItemImages,
  });

  /// Yükleme ilerlemesini stream olarak yayınlar; tamamlandığında URL döner.
  Stream<TaskSnapshot> uploadBytesWithProgress(
    Uint8List bytes,
    String fileName, {
    String? contentType,
    String directory = 'user_item_images',
  });
}

class PhotoUploadDataSourceImpl implements PhotoUploadDataSource {
  PhotoUploadDataSourceImpl(this._storage, this._auth);

  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  @override
  Future<String> uploadBytes(
    Uint8List bytes,
    String fileName, {
    String? contentType,
    String directory = 'user_item_images',
  }) async {
    final uid = _auth.currentUser?.uid;
    final baseDir = uid != null ? FirebasePaths.userScoped(uid, directory) : directory;
    final ref = _storage.ref().child(baseDir).child('${DateTime.now().millisecondsSinceEpoch}_$fileName');

    final metadata = SettableMetadata(contentType: contentType ?? 'image/jpeg');
    await ref.putData(bytes, metadata);
    return ref.getDownloadURL();
  }

  @override
  Stream<TaskSnapshot> uploadBytesWithProgress(
    Uint8List bytes,
    String fileName, {
    String? contentType,
    String directory = FirebasePaths.userItemImages,
  }) {
    final uid = _auth.currentUser?.uid;
    final baseDir = uid != null ? FirebasePaths.userScoped(uid, directory) : directory;
    final ref = _storage.ref().child(baseDir).child('${DateTime.now().millisecondsSinceEpoch}_$fileName');
    final metadata = SettableMetadata(contentType: contentType ?? 'image/jpeg');
    final task = ref.putData(bytes, metadata);
    return task.snapshotEvents;
  }
}
