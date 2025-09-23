import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/add_category_view_mixin.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/add_category_view/category_name_field.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/add_category_view/items_list.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/add_category_view/submit_button.dart';

class AddCategoryView extends StatefulWidget {
  const AddCategoryView({super.key});

  @override
  State<AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddCategoryView> with AddCategoryViewMixin {
  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.columnPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryNameField(controller: categoryController),
          const SizedBox(height: 16),
          Text(context.loc.itemsTitle),
          const SizedBox(height: 8),
          Expanded(
            child: ItemsList(
              controllers: itemControllers,
              onAdd: () => addItemField(() => setState(() {})),
              onRemove: (i) => removeItemField(() => setState(() {}), i),
            ),
          ),
          const SizedBox(height: 8),
          SubmitButton(
            onPressed: isSubmitting ? null : () => submit(context, () => setState(() {})),
            isSubmitting: isSubmitting,
          ),
        ],
      ),
    );
  }
}
