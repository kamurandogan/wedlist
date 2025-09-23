import 'package:wedlist/feature/settings/domain/repositories/collab_repository.dart';

class RemovePartner {
  RemovePartner(this._repo);
  final CollabRepository _repo;

  Future<void> call({required String meUid, required String otherUid}) =>
      _repo.removePartner(meUid: meUid, otherUid: otherUid);
}
