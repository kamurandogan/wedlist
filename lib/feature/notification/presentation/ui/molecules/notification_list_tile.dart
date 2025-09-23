import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/notification_icon.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.unread = false,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,

      color: Colors.white,
      child: ListTile(
        dense: true,
        leading: const NotificationIcon(color: AppColors.pastelPink),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: unread ? FontWeight.bold : FontWeight.normal),
        ),
        subtitle: Text(subtitle),
        trailing: unread ? const Icon(Icons.brightness_1, color: AppColors.accent) : null,
        onTap: onTap,
      ),
    );
  }
}
