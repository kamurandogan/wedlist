part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class SubscribeNotifications extends NotificationEvent {}

class MarkAllRead extends NotificationEvent {
  MarkAllRead(this.ids);
  final Set<String> ids;
}

class AcceptCollab extends NotificationEvent {
  AcceptCollab({required this.senderUid, required this.notifId});
  final String senderUid;
  final String notifId;
}

class RejectCollab extends NotificationEvent {
  RejectCollab({required this.senderUid, required this.notifId});
  final String senderUid;
  final String notifId;
}

class HandleCollabRemoved extends NotificationEvent {
  HandleCollabRemoved({required this.removerUid, required this.notifId});
  final String removerUid;
  final String notifId;
}

class _NotificationsUpdated extends NotificationEvent {
  _NotificationsUpdated(this.items);
  final List<AppNotificationEntity> items;
}

class _NotificationsError extends NotificationEvent {
  _NotificationsError(this.message);
  final String message;
}
