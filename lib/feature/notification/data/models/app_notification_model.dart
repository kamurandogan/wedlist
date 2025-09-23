import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';

class AppNotificationModel {
  AppNotificationModel({
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

  factory AppNotificationModel.fromJson(Map<String, dynamic> json, String id) {
    final ts = json['createdAt'];
    final dt = ts is Timestamp ? ts.toDate() : DateTime.tryParse(ts?.toString() ?? '') ?? DateTime.now();
    return AppNotificationModel(
      id: id,
      type: json['type'] as String? ?? 'item_added',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      itemId: json['itemId'] as String? ?? '',
      category: json['category'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: dt,
      read: json['read'] as bool? ?? false,
    );
  }

  final String id;
  final String type;
  final String title;
  final String body;
  final String itemId;
  final String category;
  final String createdBy;
  final DateTime createdAt;
  final bool read;

  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'body': body,
    'itemId': itemId,
    'category': category,
    'createdBy': createdBy,
    'createdAt': FieldValue.serverTimestamp(),
    'read': read,
  };

  AppNotificationEntity toEntity() => AppNotificationEntity(
    id: id,
    type: type,
    title: title,
    body: body,
    itemId: itemId,
    category: category,
    createdBy: createdBy,
    createdAt: createdAt,
    read: read,
  );
}
