import 'package:flutter/material.dart';
import 'package:wedlist/feature/item_add/presentation/widgets/item_add_form/error_text.dart';
// import removed: item_add_button moved/removed
import 'package:wedlist/feature/item_add/presentation/widgets/item_add_form/item_form_fields.dart';

class ItemAddForm extends StatelessWidget {
  const ItemAddForm({
    required this.formKey,
    required this.titleController,
    required this.categoryController,
    required this.onAdd,
    required this.loading,
    super.key,
    this.error,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController categoryController;
  final VoidCallback onAdd;
  final bool loading;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ItemFormFields(
            titleController: titleController,
            categoryController: categoryController,
          ),
          const SizedBox(height: 24),
          if (error != null) ...[
            ErrorText(error!),
            const SizedBox(height: 12),
          ],
          // Button moved/removed
        ],
      ),
    );
  }
}
