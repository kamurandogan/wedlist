import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_local_datasource.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_remote_datasource.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_hive_model.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_model.dart';
import 'package:wedlist/feature/item_add/domain/usecases/upload_photo_usecase.dart';

/// Migrasyon sonuç sınıfı
class MigrationResult {
  MigrationResult({
    required this.success,
    required this.migratedCount,
    required this.failedCount,
    this.failedItems = const [],
    this.errorMessage,
    this.uploadedPhotosCount = 0,
    this.failedPhotosCount = 0,
    this.failedPhotoItems = const [],
  });

  final bool success;
  final int migratedCount;
  final int failedCount;
  final List<String> failedItems; // Başarısız item ID'leri
  final String? errorMessage;

  // Photo upload tracking
  final int uploadedPhotosCount;
  final int failedPhotosCount;
  final List<String> failedPhotoItems; // Item IDs with failed photo uploads

  bool get hasFailures => failedCount > 0;
  bool get isPartialSuccess => migratedCount > 0 && failedCount > 0;
  bool get hasPhotoFailures => failedPhotosCount > 0;
}

/// Offline verileri Firebase'e taşıma servisi
///
/// Bu servis offline kullanıcı giriş yaptığında yerel Hive verilerini
/// Firebase'e taşımaktan sorumludur.
class OfflineDataMigrationService {
  OfflineDataMigrationService({
    required UserItemLocalDataSource localDataSource,
    required UserItemRemoteDataSource remoteDataSource,
    required UserModeService userModeService,
    required UploadPhotoUseCase uploadPhotoUseCase,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _userModeService = userModeService,
       _uploadPhotoUseCase = uploadPhotoUseCase;

  final UserItemLocalDataSource _localDataSource;
  final UserItemRemoteDataSource _remoteDataSource;
  final UserModeService _userModeService;
  final UploadPhotoUseCase _uploadPhotoUseCase;

  /// Offline verilerini Firebase'e taşı
  ///
  /// [localUserId]: Offline mod UUID
  /// [firebaseUid]: Firebase kullanıcı UID
  Future<MigrationResult> migrateOfflineDataToFirebase(
    String localUserId,
    String firebaseUid,
  ) async {
    try {
      // Tüm yerel öğeleri al
      final allLocalItems = await _localDataSource.getAllUserItems();

      // Local user ID ile oluşturulmuş öğeleri filtrele
      final offlineItems = allLocalItems
          .where((item) => item.createdBy == localUserId)
          .toList();

      if (offlineItems.isEmpty) {
        return MigrationResult(
          success: true,
          migratedCount: 0,
          failedCount: 0,
        );
      }

      // Batch migrasyon (25 öğe/grup)
      const batchSize = 25;
      var migratedCount = 0;
      var failedCount = 0;
      final failedItemIds = <String>[];

      // Photo tracking
      var uploadedPhotosCount = 0;
      var failedPhotosCount = 0;
      final failedPhotoItemIds = <String>[];

      for (var i = 0; i < offlineItems.length; i += batchSize) {
        final end = (i + batchSize < offlineItems.length)
            ? i + batchSize
            : offlineItems.length;
        final batch = offlineItems.sublist(i, end);

        AppLogger.info(
          '🔄 Migrating batch ${i ~/ batchSize + 1}: items ${i + 1}-$end of ${offlineItems.length}',
        );

        for (final item in batch) {
          try {
            // Migrate item and get photo upload status
            final photoStatus = await _migrateUserItem(
              item,
              localUserId,
              firebaseUid,
            );

            migratedCount++;

            // Track photo upload results
            if (photoStatus['photoUploaded'] ?? false) {
              uploadedPhotosCount++;
            }
            if (photoStatus['photoUploadFailed'] ?? false) {
              failedPhotosCount++;
              failedPhotoItemIds.add(item.id);
            }
          } on Exception catch (e, stackTrace) {
            failedCount++;
            failedItemIds.add(item.id);
            AppLogger.error(
              '❌ Failed to migrate item: ${item.title}',
              e,
              stackTrace,
            );
          }
        }

        // Her batch sonrası kısa bir gecikme (rate limiting için)
        if (end < offlineItems.length) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
      }

      // Migrasyon başarılıysa offline metadata'yı temizle
      if (failedCount == 0) {
        await _clearOfflineMetadata();
      }

      // Log final summary
      AppLogger.info(
        '✨ Migration complete: '
        'Items: $migratedCount migrated, $failedCount failed | '
        'Photos: $uploadedPhotosCount uploaded, $failedPhotosCount failed',
      );

      return MigrationResult(
        success: failedCount == 0,
        migratedCount: migratedCount,
        failedCount: failedCount,
        failedItems: failedItemIds,
        uploadedPhotosCount: uploadedPhotosCount,
        failedPhotosCount: failedPhotosCount,
        failedPhotoItems: failedPhotoItemIds,
      );
    } on Exception catch (e) {
      return MigrationResult(
        success: false,
        migratedCount: 0,
        failedCount: 0,
        errorMessage: e.toString(),
      );
    }
  }

  /// Upload photo bytes to Firebase Storage and return download URL
  /// Returns null if upload fails or no photoBytes exist
  Future<String?> _uploadItemPhoto(
    UserItemHiveModel hiveItem,
    String firebaseUid,
  ) async {
    // No photo to upload
    if (hiveItem.photoBytes == null || hiveItem.photoBytes!.isEmpty) {
      return null;
    }

    try {
      AppLogger.info(
        '📸 Uploading photo for item: ${hiveItem.title} (${hiveItem.id})',
      );

      // Generate unique filename: {itemId}_{timestamp}.jpg
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${hiveItem.id}_$timestamp.jpg';

      // Upload using existing use case (already handles user-scoped paths)
      final downloadUrl = await _uploadPhotoUseCase(
        bytes: hiveItem.photoBytes!,
        fileName: fileName,
        contentType: 'image/jpeg',
      );

      AppLogger.info('✅ Photo uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Failed to upload photo for item: ${hiveItem.title}',
        e,
        stackTrace,
      );
      return null; // Return null on failure, don't throw
    }
  }

  /// Tek bir user item'ı taşı
  /// Returns photo upload status: {photoUploaded: bool, photoUploadFailed: bool}
  Future<Map<String, bool>> _migrateUserItem(
    UserItemHiveModel hiveItem,
    String localUserId,
    String firebaseUid,
  ) async {
    var photoUploaded = false;
    var photoUploadFailed = false;

    // STEP 1: Attempt photo upload if photoBytes exist
    String? uploadedImgUrl;
    final hasPhotoBytes =
        hiveItem.photoBytes != null && hiveItem.photoBytes!.isNotEmpty;

    if (hasPhotoBytes) {
      uploadedImgUrl = await _uploadItemPhoto(hiveItem, firebaseUid);

      if (uploadedImgUrl != null) {
        photoUploaded = true;
        AppLogger.info('📸 Photo migrated for item: ${hiveItem.title}');
      } else {
        photoUploadFailed = true;
        AppLogger.warning(
          '⚠️ Photo upload failed, item will migrate without remote photo: ${hiveItem.title}',
        );
      }
    }

    // STEP 2: Determine final imgUrl
    // Priority: 1) newly uploaded URL, 2) existing imgUrl, 3) empty string
    final finalImgUrl = uploadedImgUrl ?? hiveItem.imgUrl;

    // STEP 3: Create UserItemModel with updated imgUrl
    final userItemModel = UserItemModel(
      id: hiveItem.id,
      title: hiveItem.title,
      category: hiveItem.category,
      note: hiveItem.note,
      imgUrl: finalImgUrl, // Now includes uploaded photo URL if successful
      price: hiveItem.price,
      createdAt: hiveItem.createdAt,
      owners: [firebaseUid],
      createdBy: firebaseUid,
    );

    // STEP 4: Upload to Firebase
    await _remoteDataSource.addUserItem(userItemModel);

    // STEP 5: Update local Hive item
    hiveItem
      ..createdBy = firebaseUid
      ..owners = [firebaseUid]
      ..isPendingSync = false
      ..lastSyncedAt = DateTime.now();

    // If photo was successfully uploaded, update imgUrl and clear photoBytes
    if (photoUploaded) {
      hiveItem
        ..imgUrl = uploadedImgUrl!
        ..photoBytes = null; // Clear local bytes, now stored in cloud
    }
    // If photo upload failed, keep photoBytes for retry via background sync

    await _localDataSource.updateUserItem(hiveItem);

    return {
      'photoUploaded': photoUploaded,
      'photoUploadFailed': photoUploadFailed,
    };
  }

  /// Offline metadata'yı temizle
  Future<void> _clearOfflineMetadata() async {
    await _userModeService.clearOfflineData();
  }

  /// Belirli öğeleri yeniden taşımayı dene (başarısız olanlar için)
  Future<MigrationResult> retryFailedMigration(
    List<String> failedItemIds,
    String localUserId,
    String firebaseUid,
  ) async {
    try {
      var migratedCount = 0;
      var failedCount = 0;
      final stillFailedIds = <String>[];

      // Photo tracking
      var uploadedPhotosCount = 0;
      var failedPhotosCount = 0;
      final failedPhotoItemIds = <String>[];

      for (final itemId in failedItemIds) {
        try {
          final item = await _localDataSource.getUserItem(itemId);
          if (item != null && item.createdBy == localUserId) {
            final photoStatus = await _migrateUserItem(
              item,
              localUserId,
              firebaseUid,
            );

            migratedCount++;

            // Track photo results
            if (photoStatus['photoUploaded'] ?? false) {
              uploadedPhotosCount++;
            }
            if (photoStatus['photoUploadFailed'] ?? false) {
              failedPhotosCount++;
              failedPhotoItemIds.add(item.id);
            }
          }
        } on Exception {
          failedCount++;
          stillFailedIds.add(itemId);
        }
      }

      return MigrationResult(
        success: failedCount == 0,
        migratedCount: migratedCount,
        failedCount: failedCount,
        failedItems: stillFailedIds,
        uploadedPhotosCount: uploadedPhotosCount,
        failedPhotosCount: failedPhotosCount,
        failedPhotoItems: failedPhotoItemIds,
      );
    } on Exception catch (e) {
      return MigrationResult(
        success: false,
        migratedCount: 0,
        failedCount: failedItemIds.length,
        failedItems: failedItemIds,
        errorMessage: e.toString(),
      );
    }
  }

  /// Migrasyon öncesi offline öğe sayısını döndür (UI göstergesi için)
  Future<int> getOfflineItemsCount(String localUserId) async {
    final allLocalItems = await _localDataSource.getAllUserItems();
    return allLocalItems.where((item) => item.createdBy == localUserId).length;
  }
}
