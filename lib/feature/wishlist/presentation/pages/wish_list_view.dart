import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/widgets/complated_image.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/wish_list_view/atoms/wishlist_bullet.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/wish_list_view/atoms/wishlist_tile_trailing.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/wish_list_view/molecules/wishlist_tile_content.dart';
import 'package:wedlist/injection_container.dart';

part '../widgets/wish_list_view/wish_list_tile.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.loc.loginRequiredForWishlist,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(AppRoute.login.path),
                  child: Text(context.loc.signInButtonText),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return BlocProvider(
      create: (context) => sl<WishListBloc>(),
      child: BlocBuilder<SelectCategoryCubit, String>(
        builder: (context, categoryState) {
          final langCode = Localizations.localeOf(context).languageCode;

          // Seçili kategori ve dil koduna göre ilgili wishlist ve kategori verilerini çek
          context.read<WishListBloc>().add(
            FetchWishListItems(categoryState, langCode, categoryState),
          );
          context.read<CategorylistBloc>().add(
            FetchCategoryList(langCode, categoryState),
          );
          return BlocConsumer<WishListBloc, WishListState>(
            listener: (context, state) {
              if (state is WishListError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              // Yükleniyor durumu
              if (state is WishListLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // Veri başarıyla yüklendiğinde
              else if (state is WishListLoaded) {
                return BlocBuilder<DowryListBloc, DowryListState>(
                  builder: (context, dowryState) {
                    // Kullanıcının sahip olduğu item anahtarlarını (kategori+başlık) topla (case-insensitive)
                    String keyOf(String category, String title) =>
                        '${category.trim().toLowerCase()}|${title.trim().toLowerCase()}';
                    final ownedKeys = <String>{};
                    if (dowryState is DowryListLoaded) {
                      for (final u in dowryState.items) {
                        ownedKeys.add(keyOf(u.category, u.title));
                      }
                    }
                    final filtered = ownedKeys.isEmpty
                        ? state.items
                        : state.items
                              .where(
                                (w) => !ownedKeys.contains(
                                  keyOf(w.category, w.title),
                                ),
                              )
                              .toList();
                    // UI-level dedup by normalized category+title in case upstream still contains duplicates
                    String norm(String s) => s.trim().toLowerCase();
                    final byKey = <String, ItemEntity>{};
                    for (final w in filtered) {
                      final k = '${norm(w.category)}|${norm(w.title)}';
                      byKey.putIfAbsent(k, () => w);
                    }
                    final finalList = byKey.values.toList();

                    if (finalList.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const ComplatedImage(),
                              Text(context.loc.completedCategoryText),
                            ],
                          ),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: finalList.length,
                        itemBuilder: (context, index) {
                          final item = finalList[index];
                          return Column(
                            children: [
                              WishListTile(item: item),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              }
              // Hata durumu
              else if (state is WishListError) {
                // Ayrıca sayfada da kısa bir bilgi gösterelim
                return Center(
                  child: Text(context.loc.somethingWentWrongErrorText),
                );
              }
              // Varsayılan boş durum
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
