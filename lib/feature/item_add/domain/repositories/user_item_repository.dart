import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';

abstract class UserItemRepository {
  Future<Either<Failure, Unit>> addUserItem(UserItemEntity item);
  Future<Either<Failure, UserItemEntity?>> fetchUserItemById(String id);
  Future<Either<Failure, List<UserItemEntity>>> fetchAllUserItems();
  Future<Either<Failure, Unit>> updateUserItem(UserItemEntity item);
  Future<Either<Failure, Unit>> deleteUserItem(String id);
  Stream<List<UserItemEntity>> watchAllUserItems();
}
