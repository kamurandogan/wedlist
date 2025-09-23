import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wedlist/core/constants/firebase_paths.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class RemainingDays extends StatelessWidget {
  const RemainingDays({super.key});

  Future<int?> _fetchRemainingDays() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final snap = await FirebaseFirestore.instance
        .collection(FirebasePaths.users)
        .doc(user.uid)
        .get();
    final data = snap.data();
    if (data == null) return null;
    final ts = data['weddingDate'];
    if (ts is Timestamp) {
      final wedding = ts.toDate();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weddingDay = DateTime(wedding.year, wedding.month, wedding.day);
      final diff = weddingDay.difference(today).inDays;
      return diff < 0 ? 0 : diff;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: _fetchRemainingDays(),
      builder: (context, snapshot) {
        final value = snapshot.data;
        final text = value != null ? value.toString() : '0';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.remainingDaysTitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(text, style: Theme.of(context).textTheme.headlineMedium),
          ],
        );
      },
    );
  }
}
