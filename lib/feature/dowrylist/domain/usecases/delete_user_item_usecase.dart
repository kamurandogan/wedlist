import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/item_add/domain/repositories/user_item_repository.dart';

class DeleteUserItemUseCase {
  DeleteUserItemUseCase(this.repository);
  final UserItemRepository repository;

  Future<Either<Failure, Unit>> call(String id) async {
    return repository.deleteUserItem(id);
  }
}
