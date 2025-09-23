import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class CollaboratorEmailField extends StatelessWidget {
  const CollaboratorEmailField({required this.controller, this.onSubmitted, super.key});

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: context.loc.collaboratorEmailLabel,
      ),
      onSubmitted: onSubmitted,
    );
  }
}
