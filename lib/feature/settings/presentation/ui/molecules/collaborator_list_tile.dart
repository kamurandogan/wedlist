import 'package:flutter/material.dart';
import 'package:wedlist/feature/settings/presentation/cubit/collab_cubit.dart';
import 'package:wedlist/feature/settings/presentation/ui/atoms/remove_collaborator_button.dart';

class CollaboratorListTile extends StatelessWidget {
  const CollaboratorListTile({
    required this.user,
    required this.onRemove,
    super.key,
  });

  final CollaboratorUser user;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    // debugPrint('Building CollaboratorListTile for ${user.email}');
    final title =
        (user.name.isNotEmpty ? user.name : user.email).trim().isNotEmpty
        ? (user.name.isNotEmpty ? user.name : user.email)
        : 'Kullanıcı';
    final subtitleText = user.email.trim().isNotEmpty ? user.email : null;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitleText != null ? Text(subtitleText) : null,
      trailing: RemoveCollaboratorButton(onPressed: onRemove),
    );
  }
}
