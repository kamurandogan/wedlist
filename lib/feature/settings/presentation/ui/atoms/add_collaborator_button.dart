import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/utils/colors.dart';

class AddCollaboratorButton extends StatelessWidget {
  const AddCollaboratorButton({required this.onPressed, this.enabled = true, super.key});

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enabled ? onPressed : null,

      child: Text(context.loc.addPartnerTitle, style: const TextStyle(color: AppColors.accent)),
    );
  }
}
