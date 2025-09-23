import 'package:flutter/material.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/photo_card_glass/photo_card_glass_button_area.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/photo_card_glass/photo_card_glass_container.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/photo_card_glass/photo_card_glass_content.dart';

class PhotoCardGlass extends StatelessWidget {
  const PhotoCardGlass({required this.title, required this.price, required this.note, super.key});
  final String title;
  final String price;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: PhotoCardGlassContainer(
        // İçerikte okunabilirliği artırmak için yarı saydam siyah overlay + beyaz metin
        child: Stack(
          children: [
            // Koyu arka plan (cam efektinin altında kalır)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),
            // İçerik: metinleri beyaz uygula
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhotoCardGlassContent(
                  title: title,
                  price: price,
                  note: note,
                  textColor: Colors.white,
                ),
                const Center(child: PhotoCardGlassButtonArea()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
