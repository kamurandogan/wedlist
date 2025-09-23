import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({required this.onPressed, required this.isSubmitting, super.key});
  final VoidCallback? onPressed;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size(170, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: isSubmitting
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(
                  context.loc.saveButtonText,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
