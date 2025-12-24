import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/services/network_info.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/constants/wishlist_constants.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/add_category_view.dart';
import 'package:wedlist/feature/wishlist/presentation/pages/wish_list_view.dart';
import 'package:wedlist/feature/wishlist/presentation/widgets/category_buttons/category_buttons.dart';
import 'package:wedlist/generated/l10n/app_localizations.dart';
import 'package:wedlist/injection_container.dart';

part 'presentation/widgets/offline_wishlist_placeholder.dart';
part 'presentation/widgets/search_bar.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final NetworkInfo _networkInfo = sl<NetworkInfo>();
  bool _isConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _checkConnectivity() async {
    final connected = await _networkInfo.isConnected;
    if (mounted) {
      setState(() {
        _isConnected = connected;
        _isLoading = false;
      });
    }
  }

  void _listenToConnectivityChanges() {
    _networkInfo.onConnectivityChanged.listen((connected) {
      if (mounted) {
        setState(() {
          _isConnected = connected;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_isConnected) {
      return _OfflineWishlistPlaceholder(
        onRetry: _checkConnectivity,
      );
    }

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
