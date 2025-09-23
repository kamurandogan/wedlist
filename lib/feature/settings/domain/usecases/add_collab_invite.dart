import 'package:wedlist/feature/settings/domain/repositories/collab_repository.dart';

class AddCollabInvite {
  AddCollabInvite(this._repo);
  final CollabRepository _repo;

  Future<void> call({required String meUid, required String email}) =>
      _repo.addInvite(meUid: meUid, email: email);
}
