import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
