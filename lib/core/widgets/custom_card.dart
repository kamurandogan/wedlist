import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/paddings.dart';

final class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.cardColor,
    required this.cardHeight,
    super.key,
    this.children,
  });

  final Color cardColor;
  final double cardHeight;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.smallOnlyTop,
      child: Container(
        height: MediaQuery.of(context).size.height * cardHeight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children ?? [],
          ),
        ),
      ),
    );
  }
}
