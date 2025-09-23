import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/utils/colors.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Bildirim sayısı örnek (gerçek veri ile değiştirilebilir)
    const notificationCount = 3;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const IconButton(
          onPressed: null,
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedNotification03,
            color: AppColors.textColor,
          ), // Buton büyütüldü
          padding: EdgeInsets.all(12),
        ),
        if (notificationCount > 0)
          Positioned(
            right: 1,
            top: 1,
            child: _notificationCount(notificationCount),
          ),
      ],
    );
  }

  Container _notificationCount(int notificationCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      child: Text(
        '$notificationCount',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
