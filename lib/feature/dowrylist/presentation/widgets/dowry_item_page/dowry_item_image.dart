import 'package:flutter/material.dart';

class DowryItemImage extends StatelessWidget {
  const DowryItemImage({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          height: 300,
        ),
      ),
    );
  }
}
