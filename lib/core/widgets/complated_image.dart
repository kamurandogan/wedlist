import 'package:flutter/material.dart';

class ComplatedImage extends StatelessWidget {
  const ComplatedImage({super.key});

  String get _image => 'assets/images/complate.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(_image);
  }
}
