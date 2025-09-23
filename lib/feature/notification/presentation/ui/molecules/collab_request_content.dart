import 'package:flutter/material.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/action_icon_button.dart';

class CollabRequestContent extends StatelessWidget {
  const CollabRequestContent({required this.title, required this.onAccept, required this.onReject, super.key});

  final String title;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(title, softWrap: true),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionIconButton(icon: Icons.check, color: Colors.green, onPressed: onAccept),
            ActionIconButton(icon: Icons.close, color: Colors.red, onPressed: onReject),
          ],
        ),
      ],
    );
  }
}
