part of 'add_photo_cubit.dart';

enum AddPhotoStatus { initial, loading, success, failure }

class AddPhotoState {
  const AddPhotoState({this.previewBytes, this.imageUrl, this.status = AddPhotoStatus.initial, this.progress});
  final Uint8List? previewBytes; // Platform bağımsız önizleme verisi
  final String? imageUrl; // Yüklenen görselin URL’si
  final AddPhotoStatus status;
  final double? progress; // 0.0 - 1.0

  AddPhotoState copyWith({Uint8List? previewBytes, String? imageUrl, AddPhotoStatus? status, double? progress}) {
    return AddPhotoState(
      previewBytes: previewBytes ?? this.previewBytes,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}
