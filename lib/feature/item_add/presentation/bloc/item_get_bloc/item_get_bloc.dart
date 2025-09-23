import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/feature/item_add/domain/repositories/item_repository.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/item_get_bloc/item_get_event.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/item_get_bloc/item_get_state.dart';

/// ItemAddBloc, item detaylarını asenkron olarak çeken ve state yöneten Bloc sınıfıdır.
class ItemGetBloc extends Bloc<ItemGetEvent, ItemGetState> {
  /// Repository bağımlılığı constructor ile alınır.
  ItemGetBloc(this.repository) : super(ItemGetInitial()) {
    // FetchItemDetail event'i tetiklendiğinde çalışır.
    on<FetchItemDetail>((event, emit) async {
      emit(ItemGetLoading()); // Yükleniyor durumuna geç.
      try {
        // Repository'den item'ı çek.
        final item = await repository.fetchItemById(event.id);
        if (item != null) {
          emit(ItemGetLoaded(item)); // Başarılıysa loaded state'e geç.
        } else {
          emit(ItemGetError('Item not found')); // Bulunamazsa hata state'i.
        }
      } on Exception catch (e) {
        emit(ItemGetError(e.toString())); // Diğer hatalarda hata state'i.
      }
    });
  }

  /// Item verisini sağlayan repository.
  final ItemRepository repository;
}
