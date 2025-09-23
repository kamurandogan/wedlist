import 'package:flutter/material.dart';

class HomePageCard extends StatelessWidget {
  const HomePageCard({
    required this.child,
    required this.color,
    super.key,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Card(
        elevation: 0,
        color: color.withValues(alpha: .8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsetsGeometry.all(12),
            child: child,
          ),
        ),
      ),
    );
  }
}
