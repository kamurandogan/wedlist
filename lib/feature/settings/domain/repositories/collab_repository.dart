import 'package:wedlist/feature/settings/domain/entities/collab.dart';

abstract class CollabRepository {
  Future<CollabSummary> load(String uid);
  Future<void> addInvite({required String meUid, required String email});
  Future<void> removePartner({required String meUid, required String otherUid});
}
