import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/feature/notification/data/datasources/notification_remote_data_source.dart';
import 'package:wedlist/feature/notification/data/models/app_notification_model.dart';
import 'package:wedlist/feature/notification/data/repositories/notification_repository_impl.dart';

class _MockRemote extends Mock implements NotificationRemoteDataSource {}

void main() {
  group('NotificationRepositoryImpl', () {
    test('watchMyNotifications maps model->entity', () async {
      final remote = _MockRemote();
      final repo = NotificationRepositoryImpl(remote);
      final model = AppNotificationModel(
        id: 'id1',
        type: 't',
        title: 'title',
        body: 'body',
        itemId: 'itm',
        category: 'cat',
        createdBy: 'u1',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        read: false,
      );
      when(
        remote.watchMyNotifications,
      ).thenAnswer((_) => Stream.value([model]));

      final first = await repo.watchMyNotifications().first;
      expect(first.single.id, 'id1');
      expect(first.single.title, 'title');
    });

    test('markRead forwards to remote', () async {
      final remote = _MockRemote();
      final repo = NotificationRepositoryImpl(remote);
      when(() => remote.markRead({'a'})).thenAnswer((_) async {});

      await repo.markRead({'a'});

      verify(() => remote.markRead({'a'})).called(1);
    });
  });
}
