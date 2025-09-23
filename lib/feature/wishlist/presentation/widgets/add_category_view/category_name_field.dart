import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class CategoryNameField extends StatelessWidget {
  const CategoryNameField({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: context.loc.addCategoryTextfieldLabel,
        hintText: context.loc.addCategoryTextfieldHint,
      ),
    );
  }
}
