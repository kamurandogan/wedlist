class FirebasePaths {
  FirebasePaths._();

  // Firestore
  static const String userItems = 'userItems';
  static const String users = 'users';

  // Storage base directories
  static const String userItemImages = 'user_item_images';

  // Build user scoped path
  static String userScoped(String uid, String directory) => 'users/$uid/$directory';
}
