import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.logout),
      label: Text(context.loc.logoutButtonText, style: Theme.of(context).textTheme.labelLarge),
      onPressed: onPressed,
    );
  }
}
