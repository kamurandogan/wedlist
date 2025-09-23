import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';

/// Çeyiz öğesi silme onay alt sayfası.
/// Silme işlemi burada tetiklenir; dışarıdaki buton sadece bu sheet'i açar.
class DeleteDowryItemSheet extends StatelessWidget {
  const DeleteDowryItemSheet({required this.itemId, required this.itemTitle, super.key});

  final String itemId;
  final String itemTitle;

  static Future<void> show(BuildContext context, {required String itemId, required String itemTitle}) async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DeleteDowryItemSheet(itemId: itemId, itemTitle: itemTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Material(
          color: theme.colorScheme.surface,
          elevation: 6,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28), bottom: Radius.circular(28)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: .6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  size: 52,
                  color: Colors.red,
                ),
                const SizedBox(height: 12),
                Text(
                  context.loc.deleteItemTitle,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '"$itemTitle" ${context.loc.deleteItemQuestion}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: .75),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(context.loc.deleteCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          context.read<DowryListBloc>().add(DeleteDowryItem(itemId));
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.loc.deleteItemDone)),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        label: Text(context.loc.deleteConfirm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
