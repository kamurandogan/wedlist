import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:wedlist/feature/item_add/domain/usecases/upload_photo_usecase.dart';
import 'package:wedlist/feature/item_add/domain/usecases/upload_photo_with_progress_usecase.dart';

part 'add_photo_state.dart';

class AddPhotoCubit extends Cubit<AddPhotoState> {
  AddPhotoCubit(this._uploadPhoto, this._uploadPhotoWithProgress)
    : super(const AddPhotoState());

  final UploadPhotoUseCase _uploadPhoto;
  final UploadPhotoWithProgressUseCase _uploadPhotoWithProgress;

  Future<void> pickImage() async {
    emit(state.copyWith(status: AddPhotoStatus.loading));
    try {
      String? imageUrl;
      Uint8List? previewBytes;
      // pick image for mobile/web/desktop
      if (kIsWeb) {
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: ImageSource.gallery);
        if (picked != null) {
          final bytes = await picked.readAsBytes();
          final fileName = picked.name;
          final contentType =
              picked.mimeType ?? lookupMimeType(fileName) ?? 'image/jpeg';
          debugPrint(
            '[DEBUG] Uploading image (web) $fileName (${bytes.length} bytes)',
          );
          previewBytes = bytes;
          // Progress yayınla
          await for (final p in _uploadPhotoWithProgress(
            bytes: bytes,
            fileName: fileName,
            contentType: contentType,
          )) {
            emit(
              state.copyWith(
                previewBytes: previewBytes,
                status: AddPhotoStatus.loading,
                progress: p,
              ),
            );
          }
          imageUrl = await _uploadPhoto(
            bytes: bytes,
            fileName: fileName,
            contentType: contentType,
          );
        }
      } else {
        // mobile or desktop
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: ImageSource.gallery);
        if (picked != null) {
          final bytes = await picked.readAsBytes();
          final name = picked.name;
          final contentType =
              picked.mimeType ?? lookupMimeType(name) ?? 'image/jpeg';
          debugPrint(
            '[DEBUG] Uploading image (mobile) $name (${bytes.length} bytes)',
          );
          previewBytes = bytes;
          await for (final p in _uploadPhotoWithProgress(
            bytes: bytes,
            fileName: name,
            contentType: contentType,
          )) {
            emit(
              state.copyWith(
                previewBytes: previewBytes,
                status: AddPhotoStatus.loading,
                progress: p,
              ),
            );
          }
          imageUrl = await _uploadPhoto(
            bytes: bytes,
            fileName: name,
            contentType: contentType,
          );
        } else {
          // fallback to file picker for desktop
          final result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            withData: true,
          );
          if (result != null && result.files.single.bytes != null) {
            final bytes = result.files.single.bytes!;
            final name = result.files.single.name;
            final contentType = lookupMimeType(name) ?? 'image/jpeg';
            debugPrint(
              '[DEBUG] Uploading image (desktop bytes) $name (${bytes.length} bytes)',
            );
            previewBytes = bytes;
            await for (final p in _uploadPhotoWithProgress(
              bytes: bytes,
              fileName: name,
              contentType: contentType,
            )) {
              emit(
                state.copyWith(
                  previewBytes: previewBytes,
                  status: AddPhotoStatus.loading,
                  progress: p,
                ),
              );
            }
            imageUrl = await _uploadPhoto(
              bytes: bytes,
              fileName: name,
              contentType: contentType,
            );
          }
        }
      }

      debugPrint('[DEBUG] Upload finished, imageUrl=$imageUrl');

      emit(
        state.copyWith(
          previewBytes: previewBytes,
          imageUrl: imageUrl,
          status: AddPhotoStatus.success,
        ),
      );
    } on Exception catch (e, st) {
      debugPrint('[ERROR] image upload failed: $e');
      debugPrintStack(stackTrace: st);
      emit(state.copyWith(status: AddPhotoStatus.failure));
    }
  }
}
