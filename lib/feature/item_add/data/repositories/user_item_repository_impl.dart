import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_remote_datasource.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_model.dart';
import 'package:wedlist/feature/item_add/domain/repositories/user_item_repository.dart';

class UserItemRepositoryImpl implements UserItemRepository {
  UserItemRepositoryImpl(this.remoteDataSource);
  final UserItemRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Unit>> addUserItem(UserItemEntity item) async {
    try {
      await remoteDataSource.addUserItem(UserItemModel.fromEntity(item));
      return const Right(unit);
    } on Exception catch (e) {
      // Basic mapping. Could be refined by inspecting Firebase exceptions.
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserItemEntity?>> fetchUserItemById(String id) async {
    try {
      final model = await remoteDataSource.fetchUserItemById(id);
      return Right(model?.toEntity());
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserItemEntity>>> fetchAllUserItems() async {
    try {
      final models = await remoteDataSource.fetchAllUserItems();
      return Right(models.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserItem(UserItemEntity item) async {
    try {
      await remoteDataSource.updateUserItem(UserItemModel.fromEntity(item));
      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUserItem(String id) async {
    try {
      await remoteDataSource.deleteUserItem(id);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<List<UserItemEntity>> watchAllUserItems() => remoteDataSource
      .watchAllUserItems()
      .map((models) => models.map((e) => e.toEntity()).toList());
}
