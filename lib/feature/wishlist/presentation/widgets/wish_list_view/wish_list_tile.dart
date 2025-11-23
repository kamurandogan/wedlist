part of '../../pages/wish_list_view.dart';

/// Organizm: Tek bir wishlist satırı (tile) - atomik ve moleküler bileşenlerle
class WishListTile extends StatelessWidget {
  const WishListTile({required this.item, super.key});

  final ItemEntity item;

  // Eklenmek üzere örnek WishListItem (gerçek kullanımda dışarıdan alınmalı)
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      key: ValueKey('${item.category}_${item.title}'),

      children: <Widget>[
        ListTile(
          dense: true,
          onTap: () {
            // GoRouter ile yönlendirme ve id+category'yi extra parametresiyle gönder
            GoRouter.of(context).push(
              AppRoute.addItem.path,
              extra: item,
            );
            debugPrint('DEBUG: ITEM $item');
          },
          contentPadding: EdgeInsets.zero,
          // Atom: Bullet
          leading: const WishListBullet(),
          // Molekül: Başlık ve kategori
          title: WishListTileContent(
            title: item.title,
            categoryKey: item.category,
          ),
          // Atom: Trailing buton/ikon
          trailing: WishListTileTrailing(title: item.title, item: item),
        ),
        const Divider(),
      ],
    );
  }
}
