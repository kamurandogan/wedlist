import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/empty_state.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/error_text.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/loading_indicator.dart';
import 'package:wedlist/feature/notification/presentation/ui/organisms/notifications_list.dart';
// Notification actions are handled via NotificationBloc events.

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  // Local cache to avoid re-sending mark-read for the same ids in rebuilds
  final Set<String> _markedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    // Use the globally provided NotificationBloc; don't create a new local instance here.
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading || state is NotificationInitial) {
          return const LoadingIndicator();
        }
        if (state is NotificationError) {
          return ErrorText(state.message);
        }
        final items = (state as NotificationLoaded).items;
        if (items.isEmpty) {
          return const EmptyState();
        }

        // Background-handle collab_removed
        final removedNotifs = items.where((n) => n.type == 'collab_removed').toList();
        if (removedNotifs.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            for (final n in removedNotifs) {
              context.read<NotificationBloc>().add(HandleCollabRemoved(removerUid: n.createdBy, notifId: n.id));
            }
          });
        }

        // Mark all currently visible unread notifications as read (exclude those being auto-deleted)
        final unreadIds = items.where((n) => !n.read && n.type != 'collab_removed').map((n) => n.id).toSet();
        final toMark = unreadIds.difference(_markedIds);
        if (toMark.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<NotificationBloc>().add(MarkAllRead(toMark));
          });
          _markedIds.addAll(toMark);
        }

        return NotificationsList(
          items: items,
          onAcceptCollab: (n) {
            context.read<NotificationBloc>().add(AcceptCollab(senderUid: n.createdBy, notifId: n.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.loc.notificationAcceptSuccess)),
            );
          },
          onRejectCollab: (n) {
            context.read<NotificationBloc>().add(RejectCollab(senderUid: n.createdBy, notifId: n.id));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.loc.notificationRejectSuccess)),
            );
          },
        );
      },
    );
  }
}
