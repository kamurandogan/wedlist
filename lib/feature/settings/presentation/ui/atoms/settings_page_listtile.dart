import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

class SettingsPageListtile extends StatelessWidget {
  const SettingsPageListtile({
    required this.title,
    required this.onTap,
    this.trailing,
    this.enabled = true,
    this.onDisabledTap,
    this.disabledMessage,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onDisabledTap;
  final String? disabledMessage;

  static const _defaultTrailing = Icon(
    Icons.chevron_right,
    color: AppColors.primary,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = enabled
        ? theme.textTheme.bodyMedium
        : theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor);

    return Card(
      elevation: 0,
      color: Colors.white,
      child: InkWell(
        onTap: () {
          if (enabled) {
            onTap();
            return;
          }
          if (onDisabledTap != null) {
            onDisabledTap!();
            return;
          }
          if (disabledMessage != null && disabledMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(disabledMessage!)),
            );
          }
        },
        child: ListTile(
          title: Text(title, style: textStyle),
          trailing: trailing ?? _defaultTrailing,
          enabled: enabled,
        ),
      ),
    );
  }
}
