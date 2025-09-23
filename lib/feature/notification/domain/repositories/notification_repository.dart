import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';

abstract class NotificationRepository {
  Stream<List<AppNotificationEntity>> watchMyNotifications();
  Future<void> markRead(Set<String> ids);
  Future<void> deleteMy(String id);
  Future<void> sendTo(String toUid, AppNotificationEntity notification);
}
