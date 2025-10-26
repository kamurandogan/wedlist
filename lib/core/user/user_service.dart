import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/services/user/collaboration_service.dart';
import 'package:wedlist/core/services/user/data_migration_service.dart';
import 'package:wedlist/core/services/user/profile_service.dart';
import 'package:wedlist/core/services/user/wishlist_initialization_service.dart';
import 'package:wedlist/core/user/app_user_model.dart';

/// Facade for user-related services.
/// 
/// Delegates to specialized services:
/// - ProfileService: User profile management
/// - WishlistInitializationService: Wishlist initialization
/// - CollaborationService: Partner/collaborator management
/// - DataMigrationService: Legacy data migration
class UserService {
  UserService(
    FirebaseFirestore firestore,
    FirebaseAuth auth,
  )   : _profileService = ProfileService(firestore, auth),
        _wishlistService = WishlistInitializationService(firestore, auth),
        _collaborationService = CollaborationService(firestore, auth),
        _migrationService = DataMigrationService(firestore, auth);

  final ProfileService _profileService;
  final WishlistInitializationService _wishlistService;
  final CollaborationService _collaborationService;
  final DataMigrationService _migrationService;

  // Profile operations
  Future<AppUserModel?> loadCurrent() => _profileService.loadCurrent();
  Future<void> ensureProfileInfo() => _profileService.ensureProfileInfo();

  // Wishlist operations
  Future<void> ensureWishListInitialized() =>
      _wishlistService.ensureWishListInitialized();
  Future<void> mergeWishListWithCollaborators() =>
      _wishlistService.mergeWishListWithCollaborators();
  Future<void> importPartnerWishListOnce(String partnerUid) =>
      _wishlistService.importPartnerWishListOnce(partnerUid);
  Future<void> importSelfWishListInto(String partnerUid) =>
      _wishlistService.importSelfWishListInto(partnerUid);

  // Collaboration operations
  Future<void> ensureSymmetricCollaborators() =>
      _collaborationService.ensureSymmetricCollaborators();
  Future<void> cleanUpAsymmetricCollaborators() =>
      _collaborationService.cleanUpAsymmetricCollaborators();
  Future<void> ensureUserItemsSymmetric() =>
      _collaborationService.ensureUserItemsSymmetric();
  Future<void> shareAllItemsWithPartner(String partnerUid) =>
      _collaborationService.shareAllItemsWithPartner(partnerUid);
  Future<void> sharePartnerItemsWithMe(String partnerUid) =>
      _collaborationService.sharePartnerItemsWithMe(partnerUid);
  Future<void> setSinglePartner(String partnerUid) =>
      _collaborationService.setSinglePartner(partnerUid);

  // Migration operations
  Future<void> migrateLegacyStringListsIfNeeded() =>
      _migrationService.migrateLegacyStringListsIfNeeded();
}
