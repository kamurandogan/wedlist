import 'package:flutter/material.dart';

class RemoveCollaboratorButton extends StatelessWidget {
  const RemoveCollaboratorButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.remove_circle_outline),
      onPressed: onPressed,
    );
  }
}
