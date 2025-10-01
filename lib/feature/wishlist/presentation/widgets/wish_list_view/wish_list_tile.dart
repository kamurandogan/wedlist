part of '../../pages/wish_list_view.dart';

/// Organizm: Tek bir wishlist satırı (tile) - atomik ve moleküler bileşenlerle
class WishListTile extends StatelessWidget {
  WishListTile({required this.item, super.key});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ItemEntity item;

  // Eklenmek üzere örnek WishListItem (gerçek kullanımda dışarıdan alınmalı)
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      title: WishListTileContent(title: item.title, categoryKey: item.category),
      // Atom: Trailing buton/ikon
      trailing: WishListTileTrailing(title: item.title, item: item),
    );
  }
}
