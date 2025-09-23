import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/feature/settings/presentation/cubit/collab_cubit.dart';
import 'package:wedlist/feature/settings/presentation/ui/pages/collaborators_editor.dart';

// Partner ekleme ve yönetim sayfası
// TO:DO(kamuran) : partner eklerken mail adresi yazılan kullanıcı partner ekleme özelliğini satın almış mı kontrol et. Satın almamışsa uyar ve ekleme yapma.

class CollaboratorsPage extends StatelessWidget {
  const CollaboratorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.partnerTitle),
        leading: _prevNavigationButton(context),
      ),
      body: BlocProvider(
        create: (_) => CollabCubit(
          FirebaseAuth.instance,
          FirebaseFirestore.instance,
        )..observe(),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CollaboratorsEditor(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _prevNavigationButton(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoute.settings.path);
        }
      },
    );
  }
}
