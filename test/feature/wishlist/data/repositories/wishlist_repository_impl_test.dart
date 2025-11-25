import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedlist/core/error/failures.dart';
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
      test('should return Right with items from remote data source', () async {
        // arrange
        when(
          () => mockDataSource.getItems(any(), any(), any()),
        ).thenAnswer((_) async => tItems);

        // act
        final result = await repository.getItems(tCategory, tLangCode, tId);

        // assert
        expect(result, equals(right<Failure, List<ItemEntity>>(tItems)));
        verify(
          () => mockDataSource.getItems(tCategory, tLangCode, tId),
        ).called(1);
        verifyNoMoreInteractions(mockDataSource);
      });

      test(
        'should return Right with empty list when data source returns empty',
        () async {
          // arrange
          when(
            () => mockDataSource.getItems(any(), any(), any()),
          ).thenAnswer((_) async => <ItemEntity>[]);

          // act
          final result = await repository.getItems(tCategory, tLangCode, tId);

          // assert
          result.fold(
            (failure) => fail('Should return Right'),
            (items) => expect(items, isEmpty),
          );
          verify(
            () => mockDataSource.getItems(tCategory, tLangCode, tId),
          ).called(1);
        },
      );

      test(
        'should return Left with UnexpectedFailure when exception occurs',
        () async {
          // arrange
          when(
            () => mockDataSource.getItems(any(), any(), any()),
          ).thenThrow(Exception('Network error'));

          // act
          final result = await repository.getItems(tCategory, tLangCode, tId);

          // assert
          result.fold(
            (failure) => expect(failure, isA<UnexpectedFailure>()),
            (items) => fail('Should return Left'),
          );
          verify(
            () => mockDataSource.getItems(tCategory, tLangCode, tId),
          ).called(1);
        },
      );
    });

    group('addItems', () {
      const tTitles = ['New Item 1', 'New Item 2'];

      test('should return Right when addItems succeeds', () async {
        // arrange
        when(
          () => mockDataSource.addItems(any(), any()),
        ).thenAnswer((_) async => Future<void>.value());

        // act
        final result = await repository.addItems(tCategory, tTitles);

        // assert
        expect(result, equals(right<Failure, void>(null)));
        verify(() => mockDataSource.addItems(tCategory, tTitles)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      });

      test('should return Left when addItems fails', () async {
        // arrange
        when(
          () => mockDataSource.addItems(any(), any()),
        ).thenThrow(Exception('Add failed'));

        // act
        final result = await repository.addItems(tCategory, tTitles);

        // assert
        result.fold(
          (failure) => expect(failure, isA<UnexpectedFailure>()),
          (_) => fail('Should return Left'),
        );
        verify(() => mockDataSource.addItems(tCategory, tTitles)).called(1);
      });
    });
  });
}
