import 'package:wedlist/feature/notification/domain/repositories/notification_repository.dart';

class MarkNotificationsRead {
  MarkNotificationsRead(this.repo);
  final NotificationRepository repo;

  Future<void> call(Set<String> ids) => repo.markRead(ids);
}
