import 'package:flutter/material.dart';

class SpendingLegend extends StatelessWidget {
  const SpendingLegend({required this.color, required this.label, super.key});
  final Color color;
  final String label;
  // final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        // const SizedBox(width: 8),
        // Text(value, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
