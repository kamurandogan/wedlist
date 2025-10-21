/// Firebase collection names and paths used throughout the app.
///
/// Centralizes all Firestore collection names to prevent typos
/// and make refactoring easier.
class FirebaseCollections {
  FirebaseCollections._();

  // User-related collections
  static const String users = 'users';
  static const String userItems = 'userItems';
  static const String customItems = 'customItems';

  // Country-specific collections
  /// Returns the country-specific items collection name
  /// Example: items_TR, items_US
  static String itemsByCountry(String countryCode) =>
      'items_${countryCode.toUpperCase()}';

  // Notification paths
  static const String notifications = 'notifications';

  // User document fields
  static const String userFieldCountry = 'country';
  static const String userFieldName = 'name';
  static const String userFieldEmail = 'email';
  static const String userFieldWishlist = 'wishlist';
  static const String userFieldReceivedItems = 'receivedItems';
  static const String userFieldCollaborators = 'collaborators';
  static const String userFieldWeddingDate = 'weddingDate';
  static const String userFieldAvatarUrl = 'avatarUrl';

  // Item document fields
  static const String itemFieldId = 'id';
  static const String itemFieldTitle = 'title';
  static const String itemFieldCategory = 'category';
  static const String itemFieldPrice = 'price';
  static const String itemFieldNote = 'note';
  static const String itemFieldImgUrl = 'imgUrl';
  static const String itemFieldCreatedAt = 'createdAt';
  static const String itemFieldCreatedBy = 'createdBy';
  static const String itemFieldOwners = 'owners';
}

/// Firebase Storage paths
class FirebaseStoragePaths {
  FirebaseStoragePaths._();

  /// Returns the user items storage path
  /// Example: user-items/userId/itemId/
  static String userItems(String userId, String itemId) =>
      'user-items/$userId/$itemId/';

  /// Returns the user avatar storage path
  /// Example: user-avatars/userId/
  static String userAvatar(String userId) => 'user-avatars/$userId/';

  /// Returns the custom items storage path
  /// Example: custom-items/userId/itemId/
  static String customItems(String userId, String itemId) =>
      'custom-items/$userId/$itemId/';
}
