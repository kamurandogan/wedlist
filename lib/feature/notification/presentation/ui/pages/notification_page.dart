import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/services/user_mode_service.dart';
import 'package:wedlist/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/empty_state.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/error_text.dart';
import 'package:wedlist/feature/notification/presentation/ui/atoms/loading_indicator.dart';
import 'package:wedlist/feature/notification/presentation/ui/organisms/notifications_list.dart';
import 'package:wedlist/injection_container.dart';
// Notification actions are handled via NotificationBloc events.

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  // Local cache to avoid re-sending mark-read for the same ids in rebuilds
  final Set<String> _markedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    // Check if offline mode - notifications require authentication
    return FutureBuilder<bool>(
      future: sl<UserModeService>().isOfflineMode(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        final isOffline = snapshot.data ?? false;
        if (isOffline) {
          // Offline mode - show login prompt
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.loc.offlineModeActive,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.loc.loginToSyncData,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.go(AppRoute.login.path);
                    },
                    child: Text(context.loc.loginButton),
                  ),
                ],
              ),
            ),
          );
        }

        // Authenticated mode - provide NotificationBloc if not already available
        // This handles the case where the app was started in offline mode but user logged in
        try {
          context.read<NotificationBloc>();
          // Bloc exists, use it directly
          return _buildNotificationContent(context);
        } on Exception catch (_) {
          // Bloc doesn't exist, provide it locally
          return BlocProvider(
            create: (context) =>
                sl<NotificationBloc>()..add(SubscribeNotifications()),
            child: _buildNotificationContent(context),
          );
        }
      },
    );
  }

  Widget _buildNotificationContent(BuildContext _) {
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
        final removedNotifs = items
            .where((n) => n.type == 'collab_removed')
            .toList();
        if (removedNotifs.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            for (final n in removedNotifs) {
              context.read<NotificationBloc>().add(
                HandleCollabRemoved(removerUid: n.createdBy, notifId: n.id),
              );
            }
          });
        }

        // Mark all currently visible unread notifications as read (exclude those being auto-deleted)
        final unreadIds = items
            .where((n) => !n.read && n.type != 'collab_removed')
            .map((n) => n.id)
            .toSet();
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
            context.read<NotificationBloc>().add(
              AcceptCollab(senderUid: n.createdBy, notifId: n.id),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.loc.notificationAcceptSuccess),
              ),
            );
          },
          onRejectCollab: (n) {
            context.read<NotificationBloc>().add(
              RejectCollab(senderUid: n.createdBy, notifId: n.id),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.loc.notificationRejectSuccess),
              ),
            );
          },
        );
      },
    );
  }
}
