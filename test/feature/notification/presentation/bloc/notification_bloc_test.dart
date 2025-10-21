import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';
import 'package:wedlist/feature/notification/domain/usecases/delete_notification.dart';
import 'package:wedlist/feature/notification/domain/usecases/mark_notifications_read.dart';
import 'package:wedlist/feature/notification/domain/usecases/send_notification_to_user.dart';
import 'package:wedlist/feature/notification/domain/usecases/watch_notifications.dart';
import 'package:wedlist/feature/notification/presentation/bloc/notification_bloc.dart';

class _MockWatch extends Mock implements WatchNotifications {}

class _MockMarkRead extends Mock implements MarkNotificationsRead {}

class _MockDelete extends Mock implements DeleteNotificationUseCase {}

class _MockSendTo extends Mock implements SendNotificationToUser {}

void main() {
  group('NotificationBloc', () {
    late _MockWatch watch;
    late _MockMarkRead markRead;
    late _MockDelete del;
    late _MockSendTo sendTo;

    setUp(() {
      watch = _MockWatch();
      markRead = _MockMarkRead();
      del = _MockDelete();
      sendTo = _MockSendTo();
    });

    blocTest<NotificationBloc, NotificationState>(
      'SubscribeNotifications -> Loaded with stream items',
      build: () {
        when(() => watch()).thenAnswer(
          (_) => Stream.value([
            AppNotificationEntity(
              id: 'n1',
              type: 'collab_request',
              title: 't',
              body: '',
              itemId: '',
              category: '',
              createdBy: 'u1',
              createdAt: DateTime.fromMillisecondsSinceEpoch(0),
              read: false,
            ),
          ]),
        );
        return NotificationBloc(watch, markRead, del, sendTo);
      },
      act: (b) => b.add(SubscribeNotifications()),
      expect: () => [isA<NotificationLoading>(), isA<NotificationLoaded>()],
    );

    blocTest<NotificationBloc, NotificationState>(
      'MarkAllRead triggers usecase',
      build: () {
        when(() => watch()).thenAnswer((_) => const Stream.empty());
        when(() => markRead({'a'})).thenAnswer((_) async {});
        return NotificationBloc(watch, markRead, del, sendTo);
      },
      act: (b) async {
        b.add(SubscribeNotifications());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        b.add(MarkAllRead(const {'a'}));
      },
      verify: (_) {
        verify(() => markRead({'a'})).called(1);
      },
    );
  });
}
