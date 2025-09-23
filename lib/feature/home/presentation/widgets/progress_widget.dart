/// Yatay ilerleme çubuğu ve yüzde göstergesi içeren modern bir widget.
library;

import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';

/// Ana ekranda ilerleme durumunu gösteren widget.
class ProgressWidget extends StatelessWidget {
  const ProgressWidget({super.key});

  /// İlerleme barının dolu kısmı için renk
  Color get indicatorColor => const Color(0xffffffd0);

  /// Başlık metni (context gerektirdiği için build içinde kullanacağız)
  String _title(BuildContext context) => context.loc.progressTitle;

  @override
  Widget build(BuildContext context) {
    // Firestore'da ülkeye göre seçilen items_<COUNTRY> koleksiyonundan toplam item sayısını al.
    final totalItemsFuture = _resolveItemsCollection().then<int>((collection) async {
      final s = await FirebaseFirestore.instance.collection(collection).count().get();
      return s.count ?? 0;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Text(_title(context), style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 23),
        // Yatay ilerleme çubuğu ve yüzde
        FutureBuilder<int>(
          future: totalItemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withValues(alpha: 0.18),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: const LinearProgressIndicator(minHeight: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('—%', style: Theme.of(context).textTheme.headlineMedium),
                ],
              );
            }
            final total = snapshot.hasError ? 0 : (snapshot.data ?? 0);
            return BlocBuilder<DowryListBloc, DowryListState>(
              builder: (context, state) {
                final owned = state is DowryListLoaded ? state.items.length : 0;
                final progress = total > 0 ? (owned / total).clamp(0.0, 1.0) : 0.0;
                return Row(
                  children: [
                    // İlerleme çubuğu
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Boş arka plan
                          Container(
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withValues(alpha: 0.18),
                            ),
                          ),
                          // Dolu kısım
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: indicatorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Yüzde metni
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<String> _resolveItemsCollection() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    String? code;
    final uid = auth.currentUser?.uid;
    if (uid != null) {
      try {
        final snap = await firestore.collection('users').doc(uid).get();
        code = (snap.data()?['country'] as String?)?.toUpperCase();
      } on Exception catch (_) {}
    }
    code ??= (ui.PlatformDispatcher.instance.locale.countryCode ?? '').toUpperCase();
    if (code.isEmpty) code = 'TR';
    return 'items_$code';
  }
}
