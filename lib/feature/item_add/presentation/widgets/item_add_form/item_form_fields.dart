import 'package:flutter/material.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/item_add_form/item_text_field.dart';

class ItemFormFields extends StatelessWidget {
  const ItemFormFields({
    required this.titleController,
    required this.categoryController,
    super.key,
  });

  final TextEditingController titleController;
  final TextEditingController categoryController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemTextField(
          controller: titleController,
          label: 'Başlık',
          validator: (v) => v == null || v.isEmpty ? 'Başlık giriniz' : null,
        ),
        const SizedBox(height: 16),
        ItemTextField(
          controller: categoryController,
          label: 'Kategori',
          validator: (v) => v == null || v.isEmpty ? 'Kategori giriniz' : null,
        ),
      ],
    );
  }
}
