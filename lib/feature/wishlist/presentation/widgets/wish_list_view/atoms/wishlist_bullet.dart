import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

/// Atomik: Tek bir bullet (daire) işareti
class WishListBullet extends StatelessWidget {
  const WishListBullet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
