import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/utils/colors.dart';

/// Atomik: Sağdaki ekle butonu ve ikon
class WishListTileTrailing extends StatelessWidget {
  const WishListTileTrailing({
    required this.title,
    required this.item,
    super.key,
  });
  final String title;
  final ItemEntity item;

  @override
  Widget build(BuildContext context) {
    return const HugeIcon(
      icon: HugeIcons.strokeRoundedAdd01,
      color: AppColors.primary,
      
    );
  }
}
