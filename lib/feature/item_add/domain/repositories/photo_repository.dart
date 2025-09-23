import 'dart:typed_data';

/// Fotoğraf yükleme için domain repository sözleşmesi
abstract class PhotoRepository {
  /// Verilen baytları yükler ve indirme URL'sini döner
  Future<String> uploadBytes(
    Uint8List bytes,
    String fileName, {
    String? contentType,
  });

  /// Yükleme ilerlemesini stream olarak yayınlar; tamamlanma URL'sini repodan çözümleriz.
  Stream<double> uploadBytesProgress(
    Uint8List bytes,
    String fileName, {
    String? contentType,
  });
}
