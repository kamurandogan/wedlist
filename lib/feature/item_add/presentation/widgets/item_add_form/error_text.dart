import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText(this.error, {super.key});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Text(error, style: const TextStyle(color: Colors.red));
  }
}
