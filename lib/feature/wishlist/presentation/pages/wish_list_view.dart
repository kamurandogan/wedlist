import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/item/item_entity.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/widgets/complated_image.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/wish_list_view/atoms/wishlist_bullet.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/wish_list_view/atoms/wishlist_tile_trailing.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/wish_list_view/molecules/wishlist_tile_content.dart';

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
    return const _WishListViewContent();
  }
}

class _WishListViewContent extends StatefulWidget {
  const _WishListViewContent();

  @override
  State<_WishListViewContent> createState() => _WishListViewContentState();
}

class _WishListViewContentState extends State<_WishListViewContent> {
  @override
  void initState() {
    super.initState();
    // İlk açılışta event dispatch et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectCubit = context.read<SelectCategoryCubit>();
      final initialCategory = selectCubit.state;
      final langCode = Localizations.localeOf(context).languageCode;

      // ⚡ Artık WatchWishListItems kullanıyoruz - gerçek zamanlı güncellemeler!
      context.read<WishListBloc>().add(
        WishListEvent.watch(initialCategory, langCode, initialCategory),
      );
      context.read<CategorylistBloc>().add(
        FetchCategoryList(langCode, initialCategory),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectCategoryCubit, String>(
      listener: (context, categoryState) {
        final langCode = Localizations.localeOf(context).languageCode;

        // ⚡ State değiştiğinde stream-based watch başlat
        context.read<WishListBloc>().add(
          WishListEvent.watch(categoryState, langCode, categoryState),
        );
        context.read<CategorylistBloc>().add(
          FetchCategoryList(langCode, categoryState),
        );
      },
      child: BlocConsumer<WishListBloc, WishListState>(
        // ⚡ Performans: Sadece state tipi değiştiğinde listener çalışsın
        listenWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType,
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
            orElse: () {},
          );
        },
        // ⚡ Performans: Sadece state gerçekten değiştiğinde rebuild et
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return state.when(
            // Başlangıç durumu
            initial: () => const SizedBox(),
            // Yükleniyor durumu
            loading: () => const Center(child: CircularProgressIndicator()),
            // Veri başarıyla yüklendiğinde
            loaded: (items) {
              // ✅ Filtering artık BLoC'ta yapılıyor! UI sadece render ediyor
              if (items.isEmpty) {
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
                  itemCount: items.length,
                  // itemExtent: 70, // ListTile + Divider approximate height
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return WishListTile(item: item);
                  },
                ),
              );
            },
            // Hata durumu
            error: (message) => Center(
              child: Text(context.loc.somethingWentWrongErrorText),
            ),
          );
        },
      ),
    );
  }
}
