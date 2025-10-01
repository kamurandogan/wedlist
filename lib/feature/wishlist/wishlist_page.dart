import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/constants/wishlist_constants.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/add_category_view.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/wish_list_view.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/category_buttons/category_buttons.dart';
import 'package:wedlist/injection_container.dart';

part 'presentation/widgets/search_bar.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Auth guard: kullanıcı giriş yapmadıysa login'e yönlendirin veya bilgi gösterin
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc.loginRequiredForSection,
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
      );
    }
    return BlocProvider(
      create: (_) => sl<WishListBloc>(),
      child: Column(
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
      ),
    );
  }
}
