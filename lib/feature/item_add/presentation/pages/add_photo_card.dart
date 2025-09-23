import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_photo_cubit/add_photo_cubit.dart';
import 'package:wedlist/feature/item_add/presentation/pages/photo_card_glass.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/add_photo_card/photo_card_image.dart';

class AddPhotoCard extends StatelessWidget {
  const AddPhotoCard({required this.item, required this.price, required this.note, super.key});
  final ItemEntity item;
  final String price;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 600, // Maksimum yükseklik
            ),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Stack(
                      children: [
                        const Positioned.fill(child: PhotoCardImage()),
                        PhotoCardGlass(title: item.title, price: price, note: note),
                        Positioned.fill(
                          child: BlocBuilder<AddPhotoCubit, AddPhotoState>(
                            builder: (context, state) {
                              final isLoading = state.status == AddPhotoStatus.loading;
                              final p = (state.progress ?? 0.0).clamp(0.0, 1.0);
                              if (!isLoading) return const SizedBox.shrink();
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: LinearProgressIndicator(value: p > 0 ? p : null),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${(p * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
