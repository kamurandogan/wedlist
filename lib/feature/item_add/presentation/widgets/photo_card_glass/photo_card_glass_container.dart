import 'package:flutter/material.dart';

class PhotoCardGlassContainer extends StatelessWidget {
  const PhotoCardGlassContainer({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
      ),
      child: child,
    );
  }
}
