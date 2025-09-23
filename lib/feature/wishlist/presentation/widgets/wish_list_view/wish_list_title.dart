import 'package:flutter/material.dart';

class WishListTitle extends StatelessWidget {
  const WishListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text('Wish List', style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
