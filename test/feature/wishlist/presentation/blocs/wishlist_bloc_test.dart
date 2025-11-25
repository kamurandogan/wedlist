import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/dowrylist/domain/usecases/watch_user_items_usecase.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';

class MockGetWishListItems extends Mock implements GetWishListItems {}

class MockRefreshBus extends Mock implements RefreshBus {}

class MockWatchUserItemsUseCase extends Mock implements WatchUserItemsUseCase {}

void main() {
  late WishListBloc bloc;
  late MockGetWishListItems mockGetWishListItems;
  late MockRefreshBus mockRefreshBus;
  late MockWatchUserItemsUseCase mockWatchUserItemsUseCase;

  setUp(() {
    mockGetWishListItems = MockGetWishListItems();
    mockRefreshBus = MockRefreshBus();
    mockWatchUserItemsUseCase = MockWatchUserItemsUseCase();

    // Mock RefreshBus stream
    when(() => mockRefreshBus.stream).thenAnswer(
      (_) => const Stream<RefreshEvent>.empty(),
    );

    // Mock WatchUserItemsUseCase stream
    when(() => mockWatchUserItemsUseCase.call()).thenAnswer(
      (_) => const Stream<List<UserItemEntity>>.empty(),
    );

    bloc = WishListBloc(
      mockGetWishListItems,
      mockRefreshBus,
      mockWatchUserItemsUseCase,
    );
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

    test('initial state should be WishListState.initial', () {
      expect(bloc.state, const WishListState.initial());
    });

    blocTest<WishListBloc, WishListState>(
      'emits [loading, loaded] when FetchWishListItems succeeds',
      build: () {
        when(
          () => mockGetWishListItems.call(any(), any(), any()),
        ).thenAnswer((_) async => right<Failure, List<ItemEntity>>(tItems));
        return bloc;
      },
      act: (bloc) => bloc.add(const WishListEvent.fetch(tCategory, tLangCode, tId)),
      expect: () => [
        const WishListState.loading(),
        WishListState.loaded(tItems),
      ],
      verify: (_) {
        verify(
          () => mockGetWishListItems.call(tCategory, tLangCode, tId),
        ).called(1);
      },
    );

    blocTest<WishListBloc, WishListState>(
      'emits [loading, loaded] with empty list',
      build: () {
        when(
          () => mockGetWishListItems.call(any(), any(), any()),
        ).thenAnswer((_) async => right<Failure, List<ItemEntity>>(<ItemEntity>[]));
        return bloc;
      },
      act: (bloc) => bloc.add(const WishListEvent.fetch(tCategory, tLangCode, tId)),
      expect: () => [
        const WishListState.loading(),
        const WishListState.loaded([]),
      ],
    );

    blocTest<WishListBloc, WishListState>(
      'emits [loading, error] when repository returns failure',
      build: () {
        when(() => mockGetWishListItems.call(any(), any(), any())).thenAnswer(
          (_) async => left<Failure, List<ItemEntity>>(
            const UnexpectedFailure('Test error'),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const WishListEvent.fetch(tCategory, tLangCode, tId)),
      expect: () => [
        const WishListState.loading(),
        predicate<WishListState>((state) {
          return state.maybeWhen(
            error: (message) => message.isNotEmpty,
            orElse: () => false,
          );
        }),
      ],
    );
  });
}
