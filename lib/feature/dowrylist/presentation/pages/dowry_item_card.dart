import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/entities/user_item_entity.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';

class DowryItemCard extends StatelessWidget {
  const DowryItemCard({required this.item, super.key});

  final UserItemEntity item;

  @override
  Widget build(BuildContext context) {
    final priceStr = _formatPrice(item.price);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      ),
      confirmDismiss: (direction) async {
        return showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete Item'),
            content: Text('Are you sure you want to delete "${item.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        context.read<DowryListBloc>().add(
          DowryListEvent.deleteDowryItem(item.id),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Hero(
            tag: 'dowry_item_${item.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: _ItemImage(
                  url: item.imgUrl,
                  photoBytes: item.photoBytes,
                ),
              ),
            ),
          ),
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: item.note.isNotEmpty
              ? Text(
                  item.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Text(
            '\$$priceStr',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onTap: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (context) => _FullScreenImage(item: item),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final isInt = price % 1 == 0;
    return isInt ? price.toStringAsFixed(0) : price.toStringAsFixed(2);
  }
}

class _ItemImage extends StatelessWidget {
  const _ItemImage({required this.url, this.photoBytes});
  final String url;
  final Uint8List? photoBytes;

  @override
  Widget build(BuildContext context) {
    // If we have local photoBytes, display from memory (for offline users)
    if (photoBytes != null) {
      return Image.memory(
        photoBytes!,
        fit: BoxFit.fitWidth,
        width: double.infinity,
        height: double.infinity,
      );
    }

    // Otherwise, try to load from network URL
    if (url.isEmpty) return const _PlaceholderImage();
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fitWidth,
      width: double.infinity,
      height: double.infinity,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, _) =>
          const Center(child: CircularProgressIndicator()),
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
      fit: BoxFit.fitWidth,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  const _FullScreenImage({required this.item});

  final UserItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: 'dowry_item_${item.id}',
            child: InteractiveViewer(
              child: _ItemImage(
                url: item.imgUrl,
                photoBytes: item.photoBytes,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          item.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
