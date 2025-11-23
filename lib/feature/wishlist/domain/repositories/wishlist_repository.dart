// ignore_for_file: public_member_api_docs

import 'package:fpdart/fpdart.dart';
import 'package:wedlist/core/error/failures.dart';
import 'package:wedlist/core/item/item_entity.dart';

abstract class WishListRepository {
  /// One-time fetch (existing method - kept for backward compatibility)
  Future<Either<Failure, List<ItemEntity>>> getItems(
    String category,
    String langCode,
    String id,
  );

  /// ⚡ Real-time stream (NEW - for reactive updates)
  Stream<Either<Failure, List<ItemEntity>>> getItemsStream(
    String category,
    String langCode,
    String id,
  );

  Future<Either<Failure, void>> addItems(String category, List<String> titles);
}
