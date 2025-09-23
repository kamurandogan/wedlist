class AppNotificationType {
  AppNotificationType._();
  static const collabRequest = 'collab_request';
  static const collabAccepted = 'collab_accepted';
  static const collabRejected = 'collab_rejected';
  static const collabRemoved = 'collab_removed';
  static const itemAdded = 'item_added';
  static const itemDeleted = 'item_deleted';
  // Diğer tipler gerektiğinde eklenir
}

class AppNotificationEntity {
  AppNotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.itemId,
    required this.category,
    required this.createdBy,
    required this.createdAt,
    required this.read,
  });

  final String id;
  final String type; // AppNotificationType.* değerlerinden biri
  final String title;
  final String body;
  final String itemId;
  final String category;
  final String createdBy;
  final DateTime createdAt;
  final bool read;
}
