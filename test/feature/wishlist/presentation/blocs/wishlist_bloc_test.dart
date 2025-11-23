import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/refresh/refresh_bus.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';

class MockGetWishListItems extends Mock implements GetWishListItems {}

class MockRefreshBus extends Mock implements RefreshBus {}

class MockDowryListBloc extends Mock implements DowryListBloc {}

void main() {
  late WishListBloc bloc;
  late MockGetWishListItems mockGetWishListItems;
  late MockRefreshBus mockRefreshBus;
  late MockDowryListBloc mockDowryListBloc;

  setUp(() {
    mockGetWishListItems = MockGetWishListItems();
    mockRefreshBus = MockRefreshBus();
    mockDowryListBloc = MockDowryListBloc();

    // Mock RefreshBus stream
    when(() => mockRefreshBus.stream).thenAnswer(
      (_) => const Stream<RefreshEvent>.empty(),
    );

    // Mock DowryListBloc stream and state
    when(() => mockDowryListBloc.stream).thenAnswer(
      (_) => const Stream<DowryListState>.empty(),
    );
    when(() => mockDowryListBloc.state).thenReturn(const DowryListInitial());

    bloc = WishListBloc(
      mockGetWishListItems,
      mockRefreshBus,
      mockDowryListBloc,
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
