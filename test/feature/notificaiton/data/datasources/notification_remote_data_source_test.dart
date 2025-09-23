import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedlist/feature/notification/data/datasources/notification_remote_data_source.dart';
import 'package:wedlist/feature/notification/data/models/app_notification_model.dart';

void main() {
  group('NotificationRemoteDataSource', () {
    test('watchMyNotifications returns items for current user', () async {
      final fs = FakeFirebaseFirestore();
      final user = MockUser(uid: 'u1');
      final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
      final ds = NotificationRemoteDataSourceImpl(fs, auth);

      await fs.collection('users').doc('u1').collection('notifications').add({
        'type': 't',
        'title': 'hello',
        'body': 'b',
        'itemId': 'i',
        'category': 'c',
        'createdBy': 'u2',
        'createdAt': DateTime(2020),
        'read': false,
      });

      final list = await ds.watchMyNotifications().first;
      expect(list.length, 1);
      expect(list.single.title, 'hello');
    });

    test('markRead updates read & readAt', () async {
      final fs = FakeFirebaseFirestore();
      final user = MockUser(uid: 'u1');
      final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
      final ds = NotificationRemoteDataSourceImpl(fs, auth);
      final ref = await fs.collection('users').doc('u1').collection('notifications').add({
        'type': 't',
        'title': 'x',
        'body': 'b',
        'itemId': 'i',
        'category': 'c',
        'createdBy': 'u2',
        'createdAt': DateTime(2020),
        'read': false,
      });

      await ds.markRead({ref.id});

      final snap = await ref.get();
      expect(snap.data()?['read'], true);
      expect(snap.data()?.containsKey('readAt'), true);
    });

    test('sendTo writes to other user collection', () async {
      final fs = FakeFirebaseFirestore();
      final user = MockUser(uid: 'u1');
      final auth = MockFirebaseAuth(mockUser: user, signedIn: true);
      final ds = NotificationRemoteDataSourceImpl(fs, auth);
      final model = AppNotificationModel(
        id: '',
        type: 't',
        title: 'hello',
        body: 'b',
        itemId: 'i',
        category: 'c',
        createdBy: 'u1',
        createdAt: DateTime(2020),
        read: false,
      );

      await ds.sendTo('u2', model);

      final q = await fs.collection('users').doc('u2').collection('notifications').get();
      expect(q.docs.length, 1);
      expect(q.docs.first.data()['title'], 'hello');
    });
  });
}
