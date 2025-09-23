import 'package:flutter/material.dart';

class TotalPaidAmount extends StatelessWidget {
  const TotalPaidAmount({required this.amountText, super.key});
  final String amountText;

  @override
  Widget build(BuildContext context) {
    return Text(
      amountText,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
