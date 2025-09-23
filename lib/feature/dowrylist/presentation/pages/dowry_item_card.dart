import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/photo_card_glass/photo_card_glass_container.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/photo_card_glass/photo_card_glass_content.dart';

class DowryItemCard extends StatelessWidget {
  const DowryItemCard({required this.item, super.key});

  final UserItemEntity item;

  @override
  Widget build(BuildContext context) {
    final priceStr = _formatPrice(item.price);
    return Padding(
      padding: AppPaddings.largeOnlyBottom,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AspectRatio(
              aspectRatio: 3 / 4,
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(48),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: _NetworkImage(url: item.imgUrl),
                              ),
                            ],
                          ),
                        ),
                      ),
                      PhotoCardGlassContainer(
                        child: Padding(
                          padding: AppPaddings.smallOnlyLeft,
                          child: PhotoCardGlassContent(
                            title: item.title,
                            price: priceStr,
                            note: item.note,
                            itemId: item.id,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    // Keep formatting similar to AddPhotoCard consumer (PhotoCardGlassContent prepends $)
    final isInt = price % 1 == 0;
    return isInt ? price.toStringAsFixed(0) : price.toStringAsFixed(2);
  }

  // Removed unused date formatter to satisfy lints.
}

class _NetworkImage extends StatelessWidget {
  const _NetworkImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _PlaceholderImage();
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, _) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, _, _) => const _PlaceholderImage(),
      memCacheWidth: 600,
      memCacheHeight: 800,
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://images.unsplash.com/photo-1755520795091-adf1f3f307e0?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
