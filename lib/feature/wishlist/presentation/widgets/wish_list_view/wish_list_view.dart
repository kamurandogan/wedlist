import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/wish_list_view.dart';
import 'package:wedlist/injection_container.dart';

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WishListBloc>(),
      child: BlocBuilder<SelectCategoryCubit, String>(
        builder: (context, categoryState) {
          final langCode = Localizations.localeOf(context).languageCode;

          // ⚡ Seçili kategori ve dil koduna göre stream-based watch başlat
          context.read<WishListBloc>().add(
            WatchWishListItems(categoryState, langCode, ''),
          );
          context.read<CategorylistBloc>().add(
            FetchCategoryList(langCode, categoryState),
          );
          return BlocBuilder<WishListBloc, WishListState>(
            // ⚡ Performans: Sadece state değiştiğinde rebuild et
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return state.when(
                // Başlangıç durumu
                initial: () => const SizedBox(),
                // Yükleniyor durumu
                loading: () => const Center(child: CircularProgressIndicator()),
                // Veri başarıyla yüklendiğinde
                loaded: (items) {
                  return Expanded(
                    child: Padding(
                      padding: AppPaddings.largeOnlyTop,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          // Her bir wishlist öğesi için kart ve ayraç oluştur
                          return Column(
                            children: [
                              // Tek bir wishlist öğesini gösteren widget
                              WishListTile(
                                item: item,
                              ),
                              // Altına ayraç çizgisi ekle
                              const Divider(
                                color: AppColors.dividerColor,
                                // height: 2,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
                // Hata durumu
                error: (message) => Center(
                  child: Text('${context.loc.errorPrefix} $message'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
