import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';

part '../widgets/category_button/dowry_button.dart';

class DowryCategoryButtons extends StatelessWidget {
  const DowryCategoryButtons({super.key});

  double get _heightRatio => 0.05;
  double get _spacing => 16;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * _heightRatio,
      child: BlocBuilder<CategorylistBloc, CategorylistState>(
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
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final cat = items[index].title;
                    final isSelected = cat == selected;
                    return Padding(
                      padding: EdgeInsets.only(right: _spacing),
                      child: DowryCategoryButton(
                        categoryName: cat,
                        isSelected: isSelected,
                        onPressed: () {
                          context.read<SelectCategoryCubit>().selectCategory(
                            cat,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
