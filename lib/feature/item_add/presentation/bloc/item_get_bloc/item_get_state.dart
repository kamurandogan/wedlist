import 'package:wedlist/core/item/item_entity.dart';

/// Bloc'un state'lerini temsil eden soyut sınıf.
abstract class ItemGetState {}

/// Başlangıç (idle) state.
class ItemGetInitial extends ItemGetState {}

/// Yükleniyor state'i (veri çekiliyor).
class ItemGetLoading extends ItemGetState {}

/// Veri başarıyla yüklendiğinde kullanılan state.
class ItemGetLoaded extends ItemGetState {
  ItemGetLoaded(this.item);

  /// Yüklenen item verisi.
  final ItemEntity item;
}

/// Hata oluştuğunda kullanılan state.
class ItemGetError extends ItemGetState {
  ItemGetError(this.message);

  /// Hata mesajı.
  final String message;
}
