import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/services/network_info.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/feature/wishlist/data/datasources/category_local_data_source.dart';
import 'package:wedlist/feature/wishlist/data/datasources/category_remote_data_source.dart';
import 'package:wedlist/feature/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:wedlist/feature/wishlist/data/models/category_item_model.dart';
import 'package:wedlist/feature/wishlist/domain/constants/base_categories.dart';
import 'package:wedlist/feature/wishlist/domain/entities/category_item.dart';
import 'package:wedlist/feature/wishlist/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.wishlistLocalDataSource,
    required this.userModeService,
    required this.networkInfo,
  });

  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;
  final WishlistLocalDataSource wishlistLocalDataSource;
  final UserModeService userModeService;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<CategoryItem>>> getCategories(
    String title,
    String langCode,
  ) async {
    try {
      final isOffline = await userModeService.isOfflineMode();

      if (isOffline) {
        // Offline: Extract categories from local wishlist items
        final items = await wishlistLocalDataSource.getAllWishlistItems();

        if (items.isEmpty) {
          // Hive boş - İnternet varsa ülkeye göre kategorileri çek
          if (await networkInfo.isConnected) {
            try {
              final remoteCategories = await remoteDataSource.getCategories(
                title,
                langCode,
              );

              // Cache for future offline use
              final categoriesToCache = remoteCategories
                  .map((c) => CategoryItemModel(title: c.title))
                  .toList();
              await localDataSource.cacheCategories(categoriesToCache);

              return Right(remoteCategories);
            } catch (_) {
              // Network error, fallback to base categories
              return Right(BaseCategories.getBaseCategories());
            }
          }

          // No internet, return base categories
          return Right(BaseCategories.getBaseCategories());
        }

        // Extract unique categories from local items
        final categories = items.map((e) => e.category).toSet().toList();
        return Right(
          categories.map((c) => CategoryItemModel(title: c)).toList(),
        );
      }

      // Authenticated mode: Try cache first
      final cached = await localDataSource.getCachedCategories();

      // Try remote if online
      if (await networkInfo.isConnected) {
        try {
          final remoteCategories = await remoteDataSource.getCategories(
            title,
            langCode,
          );

          // Cache remote categories
          final categoriesToCache = remoteCategories
              .map((c) => CategoryItemModel(title: c.title))
              .toList();
          await localDataSource.cacheCategories(categoriesToCache);

          return Right(remoteCategories);
        } catch (_) {
          // Remote failed, fallback to cache or base
        }
      }

      // Fallback to cache if available
      if (cached.isNotEmpty) {
        return Right(cached);
      }

      // Ultimate fallback: base categories
      return Right(BaseCategories.getBaseCategories());
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
