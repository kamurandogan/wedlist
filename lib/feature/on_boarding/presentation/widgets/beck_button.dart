import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle({
    required this.onTap,
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.size = 50,
  });
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? AppColors.primary).withValues(alpha: .3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_rounded,
            color: iconColor ?? Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
