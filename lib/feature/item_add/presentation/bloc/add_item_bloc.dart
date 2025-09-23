import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/feature/item_add/domain/usecases/add_user_item_usecase.dart';

part 'add_item_event.dart';
part 'add_item_state.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  AddItemBloc(this.addUserItemUseCase) : super(AddItemInitial()) {
    on<AddItemButtonPressed>((event, emit) async {
      emit(AddItemLoading());
      try {
        // Her kullanıcı öğesi için daima benzersiz bir Firestore ID üret
        final itemId = generateFirestoreId();
        final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        final userItem = UserItemEntity(
          double.tryParse(event.price ?? '') ?? 0.0,
          event.note ?? '',
          event.imgUrl ?? '',
          id: itemId,
          title: event.title,
          category: event.category,
          createdAt: DateTime.now(),
          owners: uid.isNotEmpty ? [uid] : const [],
          createdBy: uid,
        );
        final result = await addUserItemUseCase(userItem);
        result.match(
          (failure) => emit(AddItemFailure(failure.message)),
          (_) => emit(AddItemSuccess()),
        );
      } on Exception catch (e) {
        emit(AddItemFailure(e.toString()));
      }
    });
  }
  // Firestore'dan otomatik id üretmek için yardımcı fonksiyon
  static String generateFirestoreId() {
    return FirebaseFirestore.instance.collection(FirebasePaths.userItems).doc().id;
  }

  final AddUserItemUseCase addUserItemUseCase;
}
