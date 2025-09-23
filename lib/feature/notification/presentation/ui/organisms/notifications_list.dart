import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/feature/notification/domain/entities/app_notification_entity.dart';
import 'package:wedlist/feature/notification/presentation/ui/molecules/notification_list_tile.dart';
import 'package:wedlist/feature/notification/presentation/ui/organisms/add_collaborators_notification.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    required this.items,
    super.key,
    this.onAcceptCollab,
    this.onRejectCollab,
  });
  final List<AppNotificationEntity> items;
  final void Function(AppNotificationEntity n)? onAcceptCollab;
  final void Function(AppNotificationEntity n)? onRejectCollab;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd.MM.yyyy HH:mm');
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final n = items[index];
        if (n.type == 'collab_request') {
          return AddCollaboratorsNotification(
            title: n.title.isNotEmpty ? n.title : 'Ortaklık isteği',
            onAccept: () => onAcceptCollab?.call(n),
            onReject: () => onRejectCollab?.call(n),
          );
        }
        final icon = n.type == 'item_added'
            ? Icons.add_circle_outline
            : (n.type == 'item_deleted'
                  ? Icons.remove_circle_outline
                  : Icons.notifications_none);
        final when = df.format(n.createdAt);
        // Lokalize suffix: item title + " " + (eklendi/silindi) gibi.
        String? suffix;
        if (n.type == 'item_added') {
          suffix = context.loc.notificationItemAddedSuffix;
        } else if (n.type == 'item_deleted') {
          suffix = context.loc.notificationItemDeletedSuffix;
        }
        final computedTitle = (suffix != null && suffix.isNotEmpty)
            ? '${n.title} $suffix'
            : n.title;
        // Alt satırda kategori veya mevcut body.
        final displayBody = (n.category.isNotEmpty ? n.category : n.body);
        return NotificationListTile(
          icon: icon,
          title: computedTitle,
          subtitle: '$displayBody • $when',
          unread: !n.read,
          onTap: () {},
        );
      },
    );
  }
}
