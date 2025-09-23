part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  NotificationLoaded(this.items);
  final List<AppNotificationEntity> items;
}

class NotificationError extends NotificationState {
  NotificationError(this.message);
  final String message;
}
