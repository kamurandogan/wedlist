import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/feature/item_add/domain/repositories/user_item_repository.dart';

class WatchUserItemsUseCase {
  WatchUserItemsUseCase(this.repository);
  final UserItemRepository repository;
  Stream<List<UserItemEntity>> call() => repository.watchAllUserItems();
}
