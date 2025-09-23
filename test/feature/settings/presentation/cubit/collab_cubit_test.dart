import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';
import 'package:wedlist/feature/settings/presentation/cubit/collab_cubit.dart';

void main() {
  group('CollabCubit', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late CollabCubit cubit;
    const me = 'me';
    const other = 'other';

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        mockUser: MockUser(uid: me, email: 'me@mail.com'),
      );
      // seed users
      await firestore.collection(FirebasePaths.users).doc(me).set({
        'email': 'me@mail.com',
      });
      await firestore.collection(FirebasePaths.users).doc(other).set({
        'email': 'other@mail.com',
      });
      cubit = CollabCubit(auth, firestore);
    });

    test('initial state', () {
      expect(cubit.state.collaborators, isEmpty);
      expect(cubit.state.invites, isEmpty);
    });

    blocTest<CollabCubit, CollabState>(
      'addByEmail creates waiting invite',
      build: () => cubit,
      act: (c) async => c.addByEmail('other@mail.com'),
      wait: const Duration(milliseconds: 50),
      verify: (c) {
        expect(
          c.state.invites
              .where((i) => i.uid == other && i.status == 'waiting')
              .length,
          1,
        );
        expect(c.state.collaborators, isEmpty);
      },
    );

    blocTest<CollabCubit, CollabState>(
      'remote acceptance heals inviter document',
      build: () => cubit,
      act: (c) async {
        await c.addByEmail('other@mail.com');
        // simulate other accepts by setting collaborators on other side
        await firestore.collection(FirebasePaths.users).doc(other).set({
          'collaborators': [me],
        });
        // trigger reload
        await c.loadCollaborators();
      },
      wait: const Duration(milliseconds: 50),
      verify: (c) {
        expect(c.state.collaborators.map((e) => e.uid), contains(other));
        expect(
          c.state.invites.any((i) => i.uid == other && i.status == 'accepted'),
          isTrue,
        );
      },
    );
  });
}
