import 'package:wedlist/feature/settings/domain/entities/collab.dart';
import 'package:wedlist/feature/settings/domain/repositories/collab_repository.dart';

class LoadCollabSummary {
  LoadCollabSummary(this._repo);
  final CollabRepository _repo;

  Future<CollabSummary> call(String uid) => _repo.load(uid);
}
