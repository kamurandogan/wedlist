import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/data/repositories/wishlist_repository_impl.dart';

class MockWishListRemoteDataSource extends Mock
    implements WishListRemoteDataSource {}

void main() {
  late WishListRepositoryImpl repository;
  late MockWishListRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWishListRemoteDataSource();
    repository = WishListRepositoryImpl(mockDataSource);
  });

  group('WishListRepositoryImpl', () {
    const tCategory = 'electronics';
    const tLangCode = 'en';
    const tId = 'user123';
    final tItems = <ItemEntity>[
      ItemEntity(id: '1', title: 'Item 1', category: tCategory),
      ItemEntity(id: '2', title: 'Item 2', category: tCategory),
    ];

    group('getItems', () {
      test('should return items from remote data source', () async {
        // arrange
        when(
          () => mockDataSource.getItems(any(), any(), any()),
        ).thenAnswer((_) async => tItems);

        // act
        final result = await repository.getItems(tCategory, tLangCode, tId);

        // assert
        expect(result, equals(tItems));
        verify(
          () => mockDataSource.getItems(tCategory, tLangCode, tId),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      });

      test('should return empty list when data source returns empty', () async {
        // arrange
        when(
          () => mockDataSource.getItems(any(), any(), any()),
        ).thenAnswer((_) async => <ItemEntity>[]);

        // act
        final result = await repository.getItems(tCategory, tLangCode, tId);

        // assert
        expect(result, isEmpty);
        verify(
          () => mockDataSource.getItems(tCategory, tLangCode, tId),
        ).called(1);
      });

      test('should propagate exception from data source', () async {
        // arrange
        when(
          () => mockDataSource.getItems(any(), any(), any()),
        ).thenThrow(Exception('Network error'));

        // act & assert
        expect(
          () => repository.getItems(tCategory, tLangCode, tId),
          throwsException,
        );
        verify(
          () => mockDataSource.getItems(tCategory, tLangCode, tId),
        ).called(1);
      });
    });

    group('addItems', () {
      const tTitles = ['New Item 1', 'New Item 2'];

      test('should call data source addItems', () async {
        // arrange
        when(
          () => mockDataSource.addItems(any(), any()),
        ).thenAnswer((_) async => Future<void>.value());

        // act
        await repository.addItems(tCategory, tTitles);

        // assert
        verify(() => mockDataSource.addItems(tCategory, tTitles)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      });

      test('should propagate exception when addItems fails', () async {
        // arrange
        when(
          () => mockDataSource.addItems(any(), any()),
        ).thenThrow(Exception('Add failed'));

        // act & assert
        expect(
          () => repository.addItems(tCategory, tTitles),
          throwsException,
        );
        verify(() => mockDataSource.addItems(tCategory, tTitles)).called(1);
      });
    });
  });
}
