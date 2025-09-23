import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/feature/main_page/presentation/widgets/settings_button.dart';

part '../widgets/avatar.dart';
part '../widgets/user_title.dart';

class UserDetailLinePage extends StatelessWidget {
  const UserDetailLinePage({super.key});

  String _firstNameFrom(String? fullName, {String? fallback}) {
    final base = (fullName ?? fallback ?? '').trim();
    if (base.isEmpty) return '';
    final parts = base.split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : base;
  }

  Future<String> _loadFirstName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '';
    final uid = user.uid;
    try {
      final snap = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snap.data();
      final name = data != null ? data['name'] as String? : null;
      final displayOrEmail = user.displayName ?? user.email?.split('@').first;
      return _firstNameFrom(name, fallback: displayOrEmail);
    } on Exception {
      final displayOrEmail = user.displayName ?? user.email?.split('@').first;
      return _firstNameFrom(null, fallback: displayOrEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadFirstName(),
      builder: (context, snapshot) {
        final firstName = (snapshot.data ?? '').isNotEmpty ? snapshot.data! : '';
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName.isNotEmpty ? '${context.loc.helloText} $firstName' : context.loc.helloText,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(context.loc.welcomeMessage, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SettingsButton(),
                    // NotificationWidget(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
