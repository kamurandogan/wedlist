import 'package:flutter/material.dart';

class EmptyCategoryText extends StatelessWidget {
  const EmptyCategoryText({this.text = 'Bu kategoride öğe yok', super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
