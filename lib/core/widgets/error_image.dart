import 'package:flutter/material.dart';

class ErrorImage extends StatelessWidget {
  const ErrorImage({super.key});

  String get _image => 'assets/images/error.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(_image);
  }
}
