import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';
import 'package:wedlist/feature/notification/domain/repositories/notification_repository.dart';

class WatchNotifications {
  WatchNotifications(this.repo);
  final NotificationRepository repo;

  Stream<List<AppNotificationEntity>> call() => repo.watchMyNotifications();
}
