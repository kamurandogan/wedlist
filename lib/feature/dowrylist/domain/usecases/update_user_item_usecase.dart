import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/feature/item_add/domain/repositories/user_item_repository.dart';

class UpdateUserItemUseCase {
  UpdateUserItemUseCase(this.repository);
  final UserItemRepository repository;

  Future<Either<Failure, Unit>> call(UserItemEntity item) async {
    return repository.updateUserItem(item);
  }
}
