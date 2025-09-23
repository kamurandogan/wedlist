import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

          // Seçili kategori ve dil koduna göre ilgili wishlist ve kategori verilerini çek
          context.read<WishListBloc>().add(
            FetchWishListItems(categoryState, langCode, ''),
          );
          context.read<CategorylistBloc>().add(
            FetchCategoryList(langCode, categoryState),
          );
          return BlocBuilder<WishListBloc, WishListState>(
            builder: (context, state) {
              // Yükleniyor durumu
              if (state is WishListLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // Veri başarıyla yüklendiğinde
              else if (state is WishListLoaded) {
                return Expanded(
                  child: Padding(
                    padding: AppPaddings.largeOnlyTop,
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
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
              }
              // Hata durumu
              else if (state is WishListError) {
                return Center(child: Text('Hata: ${state.message}'));
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
