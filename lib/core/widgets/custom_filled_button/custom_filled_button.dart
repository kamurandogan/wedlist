import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

/// Uygulama genelinde kullanılabilecek özelleştirilebilir bir dolu buton.
class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.isExpanded = false,
    this.size = const Size(170, 50),
  });
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isExpanded;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final btn = FilledButton(
      style: FilledButton.styleFrom(
        fixedSize: size,
        backgroundColor: backgroundColor ?? AppColors.primary,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
    return isExpanded ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}
