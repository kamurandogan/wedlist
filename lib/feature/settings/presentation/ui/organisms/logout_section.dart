import 'package:flutter/material.dart';
import 'package:wedlist/feature/settings/presentation/ui/atoms/logout_button.dart';

class LogoutSection extends StatelessWidget {
  const LogoutSection({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: LogoutButton(onPressed: onLogout),
    );
  }
}
