import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';

class MockGetWishListItems extends Mock implements GetWishListItems {}

class MockRefreshBus extends Mock implements RefreshBus {}

void main() {
  late WishListBloc bloc;
  late MockGetWishListItems mockGetWishListItems;
  late MockRefreshBus mockRefreshBus;

  setUp(() {
    mockGetWishListItems = MockGetWishListItems();
    mockRefreshBus = MockRefreshBus();

    // Mock RefreshBus stream
    when(() => mockRefreshBus.stream).thenAnswer(
      (_) => const Stream<RefreshEvent>.empty(),
    );

    bloc = WishListBloc(mockGetWishListItems, mockRefreshBus);
  });

  tearDown(() {
    bloc.close();
  });

  group('WishListBloc', () {
    const tCategory = 'electronics';
    const tLangCode = 'en';
    const tId = 'user123';
    final tItems = <ItemEntity>[
      ItemEntity(id: '1', title: 'Item 1', category: tCategory),
      ItemEntity(id: '2', title: 'Item 2', category: tCategory),
    ];

    test('initial state should be WishListInitial', () {
      expect(bloc.state, isA<WishListInitial>());
    });

    blocTest<WishListBloc, WishListState>(
      'emits [WishListLoading, WishListLoaded] when FetchWishListItems succeeds',
      build: () {
        when(
          () => mockGetWishListItems.call(any(), any(), any()),
        ).thenAnswer((_) async => tItems);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWishListItems(tCategory, tLangCode, tId)),
      expect: () => [
        isA<WishListLoading>(),
        isA<WishListLoaded>().having((state) => state.items, 'items', tItems),
      ],
      verify: (_) {
        verify(
          () => mockGetWishListItems.call(tCategory, tLangCode, tId),
        ).called(1);
      },
    );

    blocTest<WishListBloc, WishListState>(
      'emits [WishListLoading, WishListLoaded] with empty list',
      build: () {
        when(
          () => mockGetWishListItems.call(any(), any(), any()),
        ).thenAnswer((_) async => <ItemEntity>[]);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWishListItems(tCategory, tLangCode, tId)),
      expect: () => [
        isA<WishListLoading>(),
        isA<WishListLoaded>().having((state) => state.items, 'items', isEmpty),
      ],
    );

    blocTest<WishListBloc, WishListState>(
      'emits [WishListLoading, WishListError] when Firebase exception occurs',
      build: () {
        when(() => mockGetWishListItems.call(any(), any(), any())).thenThrow(
          FirebaseException(
            plugin: 'test',
            code: 'test-error',
            message: 'Test error',
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWishListItems(tCategory, tLangCode, tId)),
      expect: () => [
        isA<WishListLoading>(),
        isA<WishListError>().having(
          (state) => state.message,
          'message',
          isNotEmpty,
        ),
      ],
    );

    blocTest<WishListBloc, WishListState>(
      'emits [WishListLoading, WishListError] when generic exception occurs',
      build: () {
        when(
          () => mockGetWishListItems.call(any(), any(), any()),
        ).thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWishListItems(tCategory, tLangCode, tId)),
      expect: () => [
        isA<WishListLoading>(),
        isA<WishListError>().having(
          (state) => state.message,
          'message',
          contains('Exception: Network error'),
        ),
      ],
    );
  });
}
