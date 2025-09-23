import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/router/app_router.dart';
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
    return IconButton(
      onPressed: () {
        // GoRouter ile yönlendirme ve id+category'yi extra parametresiyle gönder
        GoRouter.of(context).push(
          AppRoute.addItem.path,
          extra: item,
        );
        debugPrint('DEBUG: ITEM $item');
      },
      icon: const HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight01,
        color: AppColors.accent,
      ),
    );
  }
}
