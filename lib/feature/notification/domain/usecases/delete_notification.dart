import 'package:wedlist/feature/notification/domain/repositories/notification_repository.dart';

class DeleteNotificationUseCase {
  DeleteNotificationUseCase(this.repo);
  final NotificationRepository repo;

  Future<void> call(String id) => repo.deleteMy(id);
}
