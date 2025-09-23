import 'dart:typed_data';

import 'package:wedlist/feature/item_add/domain/repositories/photo_repository.dart';

class UploadPhotoUseCase {
  const UploadPhotoUseCase(this._repo);

  final PhotoRepository _repo;

  Future<String> call({
    required Uint8List bytes,
    required String fileName,
    String? contentType,
  }) {
    return _repo.uploadBytes(bytes, fileName, contentType: contentType);
  }
}
