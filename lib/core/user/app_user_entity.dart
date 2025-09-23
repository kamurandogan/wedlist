import 'package:wedlist/core/item/item_entity.dart';

class AppUserEntity {
  AppUserEntity({
    required this.uid,
    required this.email,
    required this.name,
    this.wishList = const <ItemEntity>[],
    this.receivedList = const <ItemEntity>[],
    this.collaborators = const <String>[],
  });

  final String uid;
  final String email;
  final String name;
  final List<ItemEntity> wishList;
  final List<ItemEntity> receivedList;
  final List<String> collaborators;
}
