import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/feature/notification/domain/repositories/notification_repository.dart';
import 'package:wedlist/feature/notification/domain/usecases/mark_notifications_read.dart';

class _MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  group('MarkNotificationsRead', () {
    test('repo.markRead çağrılır', () async {
      final repo = _MockNotificationRepository();
      final usecase = MarkNotificationsRead(repo);
      when(() => repo.markRead({'a', 'b'})).thenAnswer((_) async {});

      await usecase({'a', 'b'});

      verify(() => repo.markRead({'a', 'b'})).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
