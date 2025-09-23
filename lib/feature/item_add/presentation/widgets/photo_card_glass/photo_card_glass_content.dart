import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/delete_dowry_item_sheet.dart';

class PhotoCardGlassContent extends StatelessWidget {
  const PhotoCardGlassContent({
    required this.title,
    required this.price,
    required this.note,
    this.textColor = AppColors.textColor,
    this.itemId,
    this.showDelete = false,
    super.key,
  });
  final String title;
  final String price;
  final String note;
  // Silme işlemi için opsiyonel itemId (dowry list kartlarında dolu gönderilecek)
  final String? itemId;
  // Bu widget içinde buton gösterilsin mi? Varsayılan false; DowryItemCard üst layer'da gösterecek.
  final bool showDelete;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              note,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor, fontStyle: FontStyle.italic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price.isEmpty ? r'$0' : '\$$price',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
              if (itemId != null) ...[
                const SizedBox(height: 8),
                _removeDowryItemButton(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconButton _removeDowryItemButton(BuildContext context) {
    return IconButton.filledTonal(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.transparent,

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: CircleBorder(
          side: BorderSide(color: Colors.grey.withValues(alpha: .3), width: 1.2),
        ),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: () {
        DeleteDowryItemSheet.show(
          context,
          itemId: itemId!,
          itemTitle: title,
        );
      },
      icon: const Padding(
        padding: EdgeInsets.all(8),
        child: HugeIcon(
          icon: HugeIcons.strokeRoundedDelete01,
          size: 18,
          color: Colors.red,
        ),
      ),
    );
  }
}
