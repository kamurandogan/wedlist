import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
      ).thenAnswer((_) async => tItems);

      // act
      final result = await usecase.call(tCategory, tLangCode, tId);

      // assert
      expect(result, equals(tItems));
      verify(() => mockRepository.getItems(tCategory, tLangCode, tId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when repository returns empty', () async {
      // arrange
      when(
        () => mockRepository.getItems(any(), any(), any()),
      ).thenAnswer((_) async => <ItemEntity>[]);

      // act
      final result = await usecase.call(tCategory, tLangCode, tId);

      // assert
      expect(result, isEmpty);
      verify(() => mockRepository.getItems(tCategory, tLangCode, tId));
    });

    test('should propagate exception when repository throws', () async {
      // arrange
      when(
        () => mockRepository.getItems(any(), any(), any()),
      ).thenThrow(Exception('Network error'));

      // act & assert
      expect(
        () => usecase.call(tCategory, tLangCode, tId),
        throwsException,
      );
    });
  });
}
