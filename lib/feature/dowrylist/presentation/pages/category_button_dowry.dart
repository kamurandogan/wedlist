import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';

part '../widgets/category_button/dowry_button.dart';

class DowryCategoryButtons extends StatelessWidget {
  const DowryCategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorylistBloc, CategorylistState>(
      builder: (context, categoryState) {
        if (categoryState is CategorylistLoading) {
          return const SizedBox.shrink();
        }
        if (categoryState is CategorylistError) {
          return Center(child: Text('Hata: ${categoryState.message}'));
        }
        if (categoryState is CategorylistLoaded) {
          return BlocBuilder<SelectCategoryCubit, String>(
            builder: (context, selected) {
              final items = categoryState.items;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((item) {
                  final cat = item.title;
                  final isSelected = cat == selected;
                  return DowryCategoryButton(
                    categoryName: cat,
                    isSelected: isSelected,
                    onPressed: () {
                      context.read<SelectCategoryCubit>().selectCategory(
                        cat,
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
