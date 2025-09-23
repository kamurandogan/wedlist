import 'package:flutter/material.dart';

/// Molekül: Başlık ve kategori bilgisini gösteren içerik
class WishListTileContent extends StatelessWidget {
  const WishListTileContent({required this.title, required this.categoryKey, super.key});
  final String title;
  final String categoryKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(categoryKey, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
