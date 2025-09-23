import 'package:flutter/material.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/add_category_view/item_field_row.dart';

class ItemsList extends StatelessWidget {
  const ItemsList({required this.controllers, required this.onAdd, required this.onRemove, super.key});
  final List<TextEditingController> controllers;
  final void Function() onAdd;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ItemFieldRow(
            controller: controllers[index],
            index: index,
            isLast: index == controllers.length - 1,
            onAdd: onAdd,
            onRemove: () => onRemove(index),
          ),
        );
      },
    );
  }
}
