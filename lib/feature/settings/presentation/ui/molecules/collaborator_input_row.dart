import 'package:flutter/material.dart';
import 'package:wedlist/feature/settings/presentation/ui/atoms/collaborator_email_field.dart';

class CollaboratorInputRow extends StatelessWidget {
  const CollaboratorInputRow({
    required this.controller,
    required this.onAdd,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return CollaboratorEmailField(
      controller: controller,
      onSubmitted: (_) => onAdd(),
    );
  }
}
