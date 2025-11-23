import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/dowrylist/presentation/pages/category_button_dowry.dart';
import 'package:wedlist/feature/dowrylist/presentation/pages/dowry_item_list_view.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';

class DowryView extends StatefulWidget {
  const DowryView({super.key});

  @override
  State<DowryView> createState() => _DowryViewState();
}

class _DowryViewState extends State<DowryView> {
  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında listeyi çek (frame sonrası)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DowryListBloc>().add(const DowryListEvent.subscribeDowryItems());
      // Kategori butonları için kategori listesini yükle
      final langCode = Localizations.localeOf(context).languageCode;
      final selected = context.read<SelectCategoryCubit>().state;
      context.read<CategorylistBloc>().add(
        FetchCategoryList(langCode, selected),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DowryCategoryButtons(),
        SizedBox(height: 8),
        DowryItemListView(),
      ],
    );
  }
}
