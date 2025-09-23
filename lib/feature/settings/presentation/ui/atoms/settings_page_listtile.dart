import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

class SettingsPageListtile extends StatelessWidget {
  const SettingsPageListtile({required this.title, required this.onTap, this.trailing, super.key});

  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  static const _defaultTrailing = Icon(
    Icons.chevron_right,
    color: AppColors.primary,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        onTap: onTap,
        trailing: trailing ?? _defaultTrailing,
      ),
    );
  }
}
