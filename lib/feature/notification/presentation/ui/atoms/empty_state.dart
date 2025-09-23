import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message ?? context.loc.notificationsEmpty));
  }
}
