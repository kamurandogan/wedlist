import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

class SettingsPageListtile extends StatelessWidget {
  const SettingsPageListtile({
    required this.title,
    required this.onTap,
    this.trailing,
    this.enabled = true,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool enabled;

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
      child: ListTile(
        title: Text(title, style: textStyle),
        onTap: enabled ? onTap : null,
        trailing: trailing ?? _defaultTrailing,
        enabled: enabled,
      ),
    );
  }
}
