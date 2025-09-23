import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/item_add/data/datasources/user_item_remote_datasource.dart';
import 'package:wedlist/feature/item_add/data/models/user_item_model.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/feature/item_add/domain/repositories/user_item_repository.dart';

class UserItemRepositoryImpl implements UserItemRepository {
  UserItemRepositoryImpl(this.remoteDataSource);
  final UserItemRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Unit>> addUserItem(UserItemEntity item) async {
    try {
      await remoteDataSource.addUserItem(UserItemModel.fromEntity(item));
      return const Right(unit);
    } on Exception catch (e, s) {
      // Basic mapping. Could be refined by inspecting Firebase exceptions.
      return Left(UnexpectedFailure(e.toString(), s));
    }
  }

  @override
  Future<UserItemEntity?> fetchUserItemById(String id) async {
    final model = await remoteDataSource.fetchUserItemById(id);
    return model?.toEntity();
  }

  @override
  Future<List<UserItemEntity>> fetchAllUserItems() async {
    final models = await remoteDataSource.fetchAllUserItems();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateUserItem(UserItemEntity item) async {
    await remoteDataSource.updateUserItem(UserItemModel.fromEntity(item));
  }

  @override
  Future<void> deleteUserItem(String id) async {
    await remoteDataSource.deleteUserItem(id);
  }

  @override
  Stream<List<UserItemEntity>> watchAllUserItems() =>
      remoteDataSource.watchAllUserItems().map((models) => models.map((e) => e.toEntity()).toList());
}
