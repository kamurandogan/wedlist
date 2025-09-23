import 'package:flutter/material.dart';

class PhotoCarouselIndicator extends StatelessWidget {
  const PhotoCarouselIndicator({
    required this.itemCount,
    required this.currentIndex,
    super.key,
    this.activeColor = Colors.black,
    this.inactiveColor = const Color(0x33000000),
    this.size = 8.0,
    this.spacing = 6.0,
  });

  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? size * 2 : size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(size),
          ),
        );
      }),
    );
  }
}
