import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';
import 'package:wedlist/feature/notification/domain/repositories/notification_repository.dart';

class SendNotificationToUser {
  SendNotificationToUser(this.repo);
  final NotificationRepository repo;

  Future<void> call(String toUid, AppNotificationEntity notification) => repo.sendTo(toUid, notification);
}
