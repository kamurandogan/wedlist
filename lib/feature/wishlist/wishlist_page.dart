import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/constants/wishlist_constants.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/add_category_view.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/wish_list_view.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/category_buttons/category_buttons.dart';

part 'presentation/widgets/search_bar.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Wishlist hem offline hem de authenticated kullanıcılar için erişilebilir
    // Veriler local Hive'da saklanıyor, Firebase auth gerekmez
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomSearchBar(),
        const CategoryButtons(),
        BlocBuilder<SelectCategoryCubit, String>(
          builder: (context, selected) {
            if (selected == addCategorySelectionKey) {
              return const Expanded(child: AddCategoryView());
            }
            return const WishListView();
          },
        ),
      ],
    );
  }
}
