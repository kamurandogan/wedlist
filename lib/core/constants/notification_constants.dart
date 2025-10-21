/// Notification types used in the app.
///
/// Centralizes notification type strings to prevent typos
/// and provide type safety.
enum NotificationType {
  /// Collaboration request notification
  collabRequest('collab_request'),

  /// Collaboration request accepted
  collabAccepted('collab_accepted'),

  /// Collaboration request rejected
  collabRejected('collab_rejected'),

  /// Item added notification
  itemAdded('item_added'),

  /// Item deleted notification
  itemDeleted('item_deleted'),

  /// Item updated notification
  itemUpdated('item_updated');

  const NotificationType(this.value);

  /// The string value stored in Firestore
  final String value;

  /// Create NotificationType from string value
  static NotificationType? fromValue(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError('Unknown notification type: $value'),
    );
  }
}

/// Notification field names in Firestore
class NotificationFields {
  NotificationFields._();

  static const String id = 'id';
  static const String type = 'type';
  static const String title = 'title';
  static const String body = 'body';
  static const String fromUserId = 'fromUserId';
  static const String fromUserName = 'fromUserName';
  static const String toUserId = 'toUserId';
  static const String read = 'read';
  static const String readAt = 'readAt';
  static const String createdAt = 'createdAt';
  static const String data = 'data';
}
