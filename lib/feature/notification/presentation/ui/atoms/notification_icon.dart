import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.pastelBlue.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.notifications, color: color),
    );
  }
}
