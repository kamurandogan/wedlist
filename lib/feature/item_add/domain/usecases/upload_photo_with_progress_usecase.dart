import 'dart:typed_data';

import 'package:wedlist/feature/item_add/domain/repositories/photo_repository.dart';

class UploadPhotoWithProgressUseCase {
  const UploadPhotoWithProgressUseCase(this._repo);

  final PhotoRepository _repo;

  Stream<double> call({
    required Uint8List bytes,
    required String fileName,
    String? contentType,
  }) {
    return _repo.uploadBytesProgress(bytes, fileName, contentType: contentType);
  }
}
