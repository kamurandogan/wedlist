enum PhotoUploadStatus { inProgress, success, failure }

class PhotoUploadProgress {
  const PhotoUploadProgress({
    required this.status,
    this.progress,
    this.downloadUrl,
    this.error,
  });

  final PhotoUploadStatus status;

  /// 0.0 - 1.0 arası ilerleme. success/failure durumlarında null olabilir.
  final double? progress;

  /// Yükleme başarıyla bittiğinde indirme URL'si.
  final String? downloadUrl;

  /// Hata durumunda mesaj.
  final String? error;
}
