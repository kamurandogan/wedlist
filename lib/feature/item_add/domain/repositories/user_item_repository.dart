import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';

abstract class UserItemRepository {
  Future<Either<Failure, Unit>> addUserItem(UserItemEntity item);
  Future<UserItemEntity?> fetchUserItemById(String id);
  Future<List<UserItemEntity>> fetchAllUserItems();
  Future<void> updateUserItem(UserItemEntity item);
  Future<void> deleteUserItem(String id);
  Stream<List<UserItemEntity>> watchAllUserItems();
}
