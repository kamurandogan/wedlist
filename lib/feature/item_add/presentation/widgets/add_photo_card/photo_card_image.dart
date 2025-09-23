import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/feature/item_add/presentation/bloc/add_photo_cubit/add_photo_cubit.dart';

class PhotoCardImage extends StatelessWidget {
  const PhotoCardImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPhotoCubit, AddPhotoState>(
      builder: (context, state) {
        final previewBytes = state.previewBytes;
        final imageUrl = state.imageUrl;
        if (previewBytes != null) {
          return Image.memory(
            previewBytes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        }
        if (imageUrl != null && imageUrl.isNotEmpty) {
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 48)),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        return Image.network(
          'https://images.unsplash.com/photo-1755520795091-adf1f3f307e0?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image, size: 48)),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
