import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class ItemFieldRow extends StatelessWidget {
  const ItemFieldRow({
    required this.controller,
    required this.index,
    required this.isLast,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });
  final TextEditingController controller;
  final int index;
  final bool isLast;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: '${context.loc.itemFieldLabel} ${index + 1}',
              hintText: context.loc.itemFieldHint,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (isLast)
          IconButton(onPressed: onAdd, icon: const Icon(Icons.add))
        else
          IconButton(onPressed: onRemove, icon: const Icon(Icons.close)),
      ],
    );
  }
}
