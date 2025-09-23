import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/user/user_service.dart';
import 'package:wedlist/feature/wishlist/domain/usecases/add_wishlist_items.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/wishlist_bloc/wishlist_bloc.dart';
import 'package:wedlist/injection_container.dart';

mixin AddCategoryViewMixin<T extends StatefulWidget> on State<T> {
  final TextEditingController categoryController = TextEditingController();
  final List<TextEditingController> itemControllers = <TextEditingController>[
    TextEditingController(),
  ];
  bool isSubmitting = false;

  @mustCallSuper
  void disposeControllers() {
    categoryController.dispose();
    for (final c in itemControllers) {
      c.dispose();
    }
  }

  void addItemField(VoidCallback setState) {
    itemControllers.add(TextEditingController());
    setState.call();
  }

  void removeItemField(VoidCallback setState, int index) {
    if (itemControllers.length <= 1) return;
    itemControllers.removeAt(index);
    setState.call();
  }

  Future<void> submit(BuildContext context, VoidCallback setState) async {
    final name = categoryController.text.trim();
    // Items: trim, boşları at, küçük harfe göre benzersiz; orijinal başlığı koru
    final itemsMap = <String, String>{}; // key: lower, value: original
    for (final c in itemControllers) {
      final t = c.text.trim();
      if (t.isEmpty) continue;
      final key = t.toLowerCase();
      itemsMap.putIfAbsent(key, () => t);
    }
    if (name.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.loc.needCategoryErrorText)),
        );
      }
      return;
    }
    // Aynı isimde kategori varsa artık hata vermiyoruz; varsa o kategoriye yeni eşyaları ekleyeceğiz.
    final state = context.read<CategorylistBloc>().state;
    final exists =
        state is CategorylistLoaded &&
        state.items.any((e) => e.title.toLowerCase() == name.toLowerCase());

    isSubmitting = true;
    setState.call();
    try {
      // Önce veriyi kaydet (bekleme sonrası widget kalkmış olabilir)
      if (itemsMap.isNotEmpty) {
        await sl<AddWishlistItems>().call(name, itemsMap.values.toList());
      }

      if (!context.mounted) return;

      // Başarı mesajını göster (hala bu sayfadayken)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exists
                ? context.loc.categoryUpdatedText
                : context.loc.categoryCreatedText,
          ),
        ),
      );

      // Formu sıfırla
      categoryController.clear();
      itemControllers
        ..clear()
        ..add(TextEditingController());

      // En son kategori ekle ve seç (varsa no-op)
      await sl<UserService>().addCustomCategory(name);
      if (!context.mounted) return;
      final categoryBloc = context.read<CategorylistBloc>();
      final selectCubit = context.read<SelectCategoryCubit>();
      categoryBloc.add(AddCustomCategory(name));
      selectCubit.selectCategory(name);

      // Listeyi anında yenile: WishListBloc için fetch tetikle
      final langCode = Localizations.localeOf(context).languageCode;
      // WishListBloc üst seviyede sağlandığı için doğrudan erişilebilir
      context.read<WishListBloc>().add(
        FetchWishListItems(name, langCode, name),
      );
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (context.mounted) {
        isSubmitting = false;
        setState.call();
      } else {
        isSubmitting = false;
      }
    }
  }
}
