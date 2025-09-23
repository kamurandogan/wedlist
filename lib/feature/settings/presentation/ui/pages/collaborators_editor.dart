import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/settings/presentation/cubit/collab_cubit.dart';
import 'package:wedlist/feature/settings/presentation/ui/atoms/add_collaborator_button.dart';
import 'package:wedlist/feature/settings/presentation/ui/molecules/collaborator_input_row.dart';
import 'package:wedlist/feature/settings/presentation/ui/molecules/collaborator_list_tile.dart';

class CollaboratorsEditor extends StatefulWidget {
  const CollaboratorsEditor({super.key});

  @override
  State<CollaboratorsEditor> createState() => _CollaboratorsEditorState();
}

class _CollaboratorsEditorState extends State<CollaboratorsEditor> {
  final _controller = TextEditingController();
  bool _canAdd = false;
  int _prevCount = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _canAdd = _controller.text.trim().isNotEmpty;
    _controller.addListener(() {
      final can = _controller.text.trim().isNotEmpty;
      if (can != _canAdd) {
        setState(() => _canAdd = can);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(BuildContext context) {
    final email = _controller.text.trim();
    if (email.isNotEmpty) {
      context.read<CollabCubit>().addByEmail(email, context: context);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollabCubit, CollabState>(
      listenWhen: (previous, current) =>
          previous.loading != current.loading ||
          previous.error != current.error ||
          previous.collaborators.length != current.collaborators.length,
      listener: (context, state) {
        if (state.loading) return;
        if (!_initialized) {
          _prevCount = state.collaborators.length;
          _initialized = true;
          return;
        }
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
          return;
        }
        final count = state.collaborators.length;
        if (count > _prevCount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.partnerAdded)),
          );
        } else if (count < _prevCount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.partnerRemoved)),
          );
        }
        _prevCount = count;
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.addPartnerTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // Partner varsa veya bekleyen davet (waiting) varsa input & buton gizlenir
            BlocBuilder<CollabCubit, CollabState>(
              buildWhen: (p, c) =>
                  p.collaborators.length != c.collaborators.length ||
                  p.invites.length != c.invites.length ||
                  p.loading != c.loading,
              builder: (context, state) {
                final hasPartner = state.collaborators.isNotEmpty;
                final hasWaiting = state.invites.any(
                  (i) => i.status == 'waiting',
                );
                if (hasPartner || hasWaiting) {
                  final msg = hasPartner
                      ? context
                            .loc
                            .partnerTitle // reuse existing key; or create a new one later
                      : context
                            .loc
                            .pendingInvitations; // shows generic pending heading
                  return Padding(
                    padding: AppPaddings.smallOnlyTop,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            msg,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.orange[800]),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppPaddings.smallOnlyTop,
                      child: CollaboratorInputRow(
                        controller: _controller,
                        onAdd: () => _add(context),
                      ),
                    ),
                    Padding(
                      padding: AppPaddings.mediumOnlyTop,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AddCollaboratorButton(
                          onPressed: () => _add(context),
                          enabled: !hasPartner && _canAdd && !state.loading,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: AppPaddings.xLargeOnlyTop,
              child: BlocBuilder<CollabCubit, CollabState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const LinearProgressIndicator();
                  }
                  if (state.error != null) {
                    return Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  final waitingInvites = state.invites
                      .where((i) => i.status == 'waiting')
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (waitingInvites.isNotEmpty) ...[
                        Text(
                          context.loc.pendingInvitations,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ...waitingInvites.map(
                          (i) => Row(
                            children: [
                              const Icon(
                                Icons.hourglass_bottom,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  i.email,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  context.loc.pendingText,
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (state.collaborators.isEmpty)
                        Text(
                          context.loc.noPartnersText,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      else
                        Column(
                          children: state.collaborators
                              .map(
                                (c) => CollaboratorListTile(
                                  user: c,
                                  onRemove: () => context
                                      .read<CollabCubit>()
                                      .remove(c.uid, context: context),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
