import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/get_wishlist_items.dart';

class MockWishListRepository extends Mock implements WishListRepository {}

void main() {
  late GetWishListItems usecase;
  late MockWishListRepository mockRepository;

  setUp(() {
    mockRepository = MockWishListRepository();
    usecase = GetWishListItems(mockRepository);
  });

  group('GetWishListItems', () {
    const tCategory = 'electronics';
    const tLangCode = 'en';
    const tId = 'user123';
    final tItems = <ItemEntity>[
      ItemEntity(
        id: '1',
        title: 'Test Item 1',
        category: tCategory,
      ),
      ItemEntity(
        id: '2',
        title: 'Test Item 2',
        category: tCategory,
      ),
    ];

    test('should get wishlist items from repository', () async {
      // arrange
      when(
        () => mockRepository.getItems(any(), any(), any()),
      ).thenAnswer((_) async => right<Failure, List<ItemEntity>>(tItems));

      // act
      final result = await usecase.call(tCategory, tLangCode, tId);

      // assert
      expect(result, equals(right<Failure, List<ItemEntity>>(tItems)));
      verify(() => mockRepository.getItems(tCategory, tLangCode, tId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when repository returns empty', () async {
      // arrange
      when(
        () => mockRepository.getItems(any(), any(), any()),
      ).thenAnswer(
        (_) async => right<Failure, List<ItemEntity>>(<ItemEntity>[]),
      );

      // act
      final result = await usecase.call(tCategory, tLangCode, tId);

      // assert
      result.fold(
        (failure) => fail('Should return Right'),
        (items) => expect(items, isEmpty),
      );
      verify(() => mockRepository.getItems(tCategory, tLangCode, tId));
    });

    test('should return Left when repository returns failure', () async {
      // arrange
      const tFailure = UnexpectedFailure('Network error');
      when(
        () => mockRepository.getItems(any(), any(), any()),
      ).thenAnswer((_) async => left<Failure, List<ItemEntity>>(tFailure));

      // act
      final result = await usecase.call(tCategory, tLangCode, tId);

      // assert
      expect(result, equals(left<Failure, List<ItemEntity>>(tFailure)));
      verify(() => mockRepository.getItems(tCategory, tLangCode, tId));
    });
  });
}
