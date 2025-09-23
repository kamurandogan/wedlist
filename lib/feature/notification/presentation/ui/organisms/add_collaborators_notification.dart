import 'package:flutter/material.dart';
import 'package:wedlist/feature/notification/presentation/ui/molecules/collab_request_content.dart';

class AddCollaboratorsNotification extends StatelessWidget {
  const AddCollaboratorsNotification({
    required this.title,
    required this.onAccept,
    required this.onReject,
    super.key,
  });

  final String title;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.group_add),
      title: CollabRequestContent(
        title: title,
        onAccept: onAccept,
        onReject: onReject,
      ),
    );
  }
}
