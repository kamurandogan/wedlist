import 'dart:typed_data';

import 'package:wedlist/feature/item_add/data/datasources/photo_upload_datasource.dart';
import 'package:wedlist/feature/item_add/domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl(this._dataSource);

  final PhotoUploadDataSource _dataSource;

  @override
  Future<String> uploadBytes(
    Uint8List bytes,
    String fileName, {
    String? contentType,
  }) {
    return _dataSource.uploadBytes(bytes, fileName, contentType: contentType);
  }

  @override
  Stream<double> uploadBytesProgress(
    Uint8List bytes,
    String fileName, {
    String? contentType,
  }) async* {
    await for (final snap in _dataSource.uploadBytesWithProgress(
      bytes,
      fileName,
      contentType: contentType,
    )) {
      final total = snap.totalBytes;
      final transferred = snap.bytesTransferred;
      if (total > 0) {
        yield transferred / total;
      } else {
        yield 0.0;
      }
    }
  }
}
