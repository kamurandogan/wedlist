import 'package:wedlist/feature/notification/data/datasources/notification_remote_data_source.dart';
import 'package:wedlist/feature/notification/data/models/app_notification_model.dart';
import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';
import 'package:wedlist/feature/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this.remote);
  final NotificationRemoteDataSource remote;

  @override
  Stream<List<AppNotificationEntity>> watchMyNotifications() => remote
      .watchMyNotifications()
      .map((m) => m.map((e) => e.toEntity()).toList());

  @override
  Future<void> markRead(Set<String> ids) => remote.markRead(ids);

  @override
  Future<void> deleteMy(String id) => remote.deleteMy(id);

  @override
  Future<void> sendTo(String toUid, AppNotificationEntity notification) {
    final model = AppNotificationModel(
      id: notification.id,
      type: notification.type,
      title: notification.title,
      body: notification.body,
      itemId: notification.itemId,
      category: notification.category,
      createdBy: notification.createdBy,
      createdAt: notification.createdAt,
      read: notification.read,
    );
    return remote.sendTo(toUid, model);
  }
}
