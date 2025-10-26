import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedlist/core/constants/firebase_constants.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/item/item_model.dart' as core;
import 'package:wedlist/core/logging/app_logger.dart';
import 'package:wedlist/core/user/app_user_model.dart';

class DataMigrationService {
  DataMigrationService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> migrateLegacyStringListsIfNeeded() async {
    final uid = _uid;
    if (uid == null) return;

    try {
      final ref = _firestore.collection(FirebaseCollections.users).doc(uid);
      final snap = await ref.get();
      if (!snap.exists) return;

      final data = snap.data() ?? {};
      final wl = (data['wishList'] as List?) ?? [];
      final rl = (data['receivedList'] as List?) ?? [];

      bool isStringList(List<dynamic> list) =>
          list.isNotEmpty && list.every((e) => e is String);

      if (!isStringList(wl) && !isStringList(rl)) return;

      final titleMap = await _buildTitleMap(data, uid);

      List<Map<String, dynamic>> convert(List<dynamic> list) {
        if (isStringList(list)) {
          final res = <Map<String, dynamic>>[];
          for (final s in list.cast<String>()) {
            final key = s.trim().toLowerCase();
            final found = titleMap[key];
            if (found != null) {
              res.add(core.ItemModel.fromEntity(found).toJson());
            } else {
              final id = key.replaceAll(' ', '_');
              res.add({'id': id, 'title': s, 'category': 'General'});
            }
          }
          return res;
        }
        return list.whereType<Map<String, dynamic>>().toList();
      }

      final newWL = convert(wl);
      final newRL = convert(rl);

      await ref.set({
        'wishList': newWL,
        'receivedList': newRL,
      }, SetOptions(merge: true));
    } catch (e, s) {
      AppLogger.error('Failed to migrate legacy string lists', e, s);
    }
  }

  Future<Map<String, ItemEntity>> _buildTitleMap(
    Map<String, dynamic> data,
    String uid,
  ) async {
    final titleMap = <String, ItemEntity>{};
    final country = (data['country'] as String?)?.toUpperCase();
    final col = country != null && country.isNotEmpty
        ? 'items_$country'
        : 'items_US';

    final base = await _firestore.collection(col).get();
    for (final d in base.docs) {
      final m = core.ItemModel.fromJson({
        'id': d.data()['id'] ?? d.id,
        'title': d.data()['title'],
        'category': d.data()['category'],
      });
      final e = m.toEntity();
      titleMap[e.title.trim().toLowerCase()] = e;
    }

    final meModel = AppUserModel.fromJson(data, uid);
    final owners = {uid, ...meModel.collaborators}.toList();
    final custom = await _firestore
        .collection(FirebaseCollections.customItems)
        .where('owners', arrayContainsAny: owners)
        .get();

    for (final d in custom.docs) {
      final m = core.ItemModel.fromJson({
        'id': d.data()['id'] ?? d.id,
        'title': d.data()['title'],
        'category': d.data()['category'],
      });
      final e = m.toEntity();
      titleMap[e.title.trim().toLowerCase()] = e;
    }

    return titleMap;
  }
}
