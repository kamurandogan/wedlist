import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_photo_cubit/add_photo_cubit.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/add_photo_card/photo_card_button.dart';

class PhotoCardGlassButtonArea extends StatelessWidget {
  const PhotoCardGlassButtonArea({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPhotoCubit, AddPhotoState>(
      // ⚡ PERFORMANS: Sadece status veya image değiştiğinde rebuild
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.previewBytes != current.previewBytes ||
          previous.imageUrl != current.imageUrl,
      builder: (context, state) {
        if (state.status == AddPhotoStatus.success &&
            (state.previewBytes != null ||
                (state.imageUrl != null && state.imageUrl!.isNotEmpty))) {
          return const SizedBox.shrink();
        }
        return Builder(
          builder: (context) => PhotoCardButton(
            onPressed: () {
              context.read<AddPhotoCubit>().pickImage();
            },
          ),
        );
      },
    );
  }
}
