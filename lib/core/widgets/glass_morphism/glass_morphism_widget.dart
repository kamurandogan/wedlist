import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({
    required this.child,
    super.key,
    this.blur = 10,
    this.opacity = 0.2,
    this.color = Colors.white,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.image,
  });

  final String? image;
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: image == null
            ? null
            : DecorationImage(
                image: NetworkImage(image ??
                    'https://as1.ftcdn.net/v2/jpg/01/42/29/00/1000_F_142290090_YPNXXDIEPdWTexzA0dDjwoft119I8GfW.jpg'),
                fit: BoxFit.cover,
              ),
        color: color.withValues(alpha: opacity),
        borderRadius: borderRadius,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: child,
        ),
      ),
    );
  }
}
