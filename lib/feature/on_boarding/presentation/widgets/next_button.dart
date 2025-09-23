import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

class NextButton extends StatelessWidget {
  const NextButton({
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
          color: backgroundColor ?? AppColors.bg,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? AppColors.primary).withValues(
                alpha: .3,
              ),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward_rounded,
            color: iconColor ?? AppColors.textColor,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
