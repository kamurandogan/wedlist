import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/utils/colors.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.push(AppRoute.settings.path),

      icon: const HugeIcon(
        icon: HugeIcons.strokeRoundedSettings02,
        color: AppColors.textColor,
      ), // Buton büyütüldü
      padding: const EdgeInsets.all(12),
    );
  }
}
