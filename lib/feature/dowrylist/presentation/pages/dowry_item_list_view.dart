import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/dowrylist/presentation/pages/dowry_item_card.dart';
import 'package:wedlist/feature/dowrylist/presentation/widgets/dowry_item_list_view/dowty_list_loading_indicator.dart';
import 'package:wedlist/feature/dowrylist/presentation/widgets/dowry_item_list_view/empty_category_text.dart';
import 'package:wedlist/feature/dowrylist/presentation/widgets/dowry_item_list_view/error_text.dart';
import 'package:wedlist/feature/item_add/domain/entities/user_item_entity.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';

class DowryItemListView extends StatelessWidget {
  const DowryItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SelectCategoryCubit, String>(
        builder: (context, selectedCategory) {
          return BlocBuilder<DowryListBloc, DowryListState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => const DowtyListLoadingIndicator(),
                error: (message) => ErrorText(text: message),
                loaded: (items) {
                  final filtered =
                      (selectedCategory.isEmpty
                            ? List<UserItemEntity>.of(items)
                            : items.where((e) => e.category == selectedCategory).toList())
                        ..sort((a, b) {
                          final epoch = DateTime.fromMillisecondsSinceEpoch(0);
                          final da = a.createdAt ?? epoch;
                          final db = b.createdAt ?? epoch;
                          return db.compareTo(da);
                        });
                  if (filtered.isEmpty) {
                    return const EmptyCategoryText();
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      if (kDebugMode) {
                        debugPrint(
                          'Item: ${item.title}, Category: ${item.category}, Image URL: ${item.imgUrl}',
                        );
                      }
                      return DowryItemCard(item: item);
                    },
                  );
                },
                empty: (_) => const EmptyCategoryText(),
                orElse: () => const ErrorText(text: 'Liste yüklenemedi'),
              );
            },
          );
        },
      ),
    );
  }
}
