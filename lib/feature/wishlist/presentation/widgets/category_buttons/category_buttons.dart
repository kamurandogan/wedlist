import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/feature/dowrylist/presentation/blocs/bloc/dowry_list_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/category_bloc/bloc/categorylist_bloc.dart';
import 'package:wedlist/feature/wishlist/presentation/blocs/cubit/select_category_cubit.dart';
import 'package:wedlist/feature/wishlist/presentation/constants/wishlist_constants.dart';

part 'category_button.dart';

class CategoryButtons extends StatefulWidget {
  const CategoryButtons({super.key});

  @override
  State<CategoryButtons> createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  // Cached map of wishlist titles per category for the current user
  final Map<String, Set<String>> _wishByCategory = {};
  bool _wishlistLoaded = false;

  // Colors are defined within button styles when needed.

  @override
  void initState() {
    super.initState();
    _loadWishlistOnce();
  }

  String _norm(String s) => s.trim().toLowerCase();

  Future<void> _loadWishlistOnce() async {
    if (_wishlistLoaded) return;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        setState(
          () => _wishlistLoaded = true,
        ); // nothing to load when not logged in
        return;
      }
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final rawList = (snap.data()?['wishList'] as List?)
          ?.whereType<Map<String, dynamic>>();
      if (rawList != null) {
        for (final j in rawList) {
          final cat = (j['category'] as String?)?.trim();
          final title = (j['title'] as String?)?.trim();
          if (cat == null || cat.isEmpty || title == null || title.isEmpty) {
            continue;
          }
          final normCat = _norm(cat);
          _wishByCategory.putIfAbsent(normCat, () => <String>{}).add(title);
        }
      }
    } on Exception {
      // ignore errors; fallback to show all buttons
    } finally {
      if (mounted) setState(() => _wishlistLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _categoryButtonBuilder();
  }

  BlocBuilder<CategorylistBloc, CategorylistState> _categoryButtonBuilder() {
    /// Tek bir kategori butonunu temsil eden widget (ayrıntı için category_button.dart'a bakınız)
    return BlocBuilder<CategorylistBloc, CategorylistState>(
      builder: (context, categorystate) {
        if (categorystate is CategorylistLoading) {
          return const SizedBox.shrink();

          /// Buton yüksekliğinin ekrana oranı
        } else if (categorystate is CategorylistError) {
          /// Hata durumunda kullanıcıya üstte SnackBar ile bilgi verelim
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final contextFromBuilder = context;
            ScaffoldMessenger.of(contextFromBuilder).showSnackBar(
              SnackBar(content: Text(categorystate.message)),
            );
          });
          return const SizedBox.shrink();
        } else if (categorystate is CategorylistLoaded) {
          // Kategori butonlarını; tamamlanmış (tüm öğeleri eklenmiş) kategorileri gizleyerek göster.
          return BlocBuilder<DowryListBloc, DowryListState>(
            builder: (context, dowryState) {
              return BlocBuilder<SelectCategoryCubit, String>(
                builder: (context, selectCategoryState) {
                  final allCategories = categorystate.items;

                  // Eğer wishlist henüz yüklenmediyse, filtre uygulamadan tüm kategorileri göster.
                  // Bu, gereksiz UI titremesini önler.
                  final wish = _wishlistLoaded
                      ? _wishByCategory
                      : const <String, Set<String>>{};

                  String keyOf(String category, String title) =>
                      '${_norm(category)}|${_norm(title)}';
                  final ownedKeys = <String>{};
                  if (dowryState is DowryListLoaded) {
                    for (final u in dowryState.items) {
                      ownedKeys.add(keyOf(u.category, u.title));
                    }
                  }

                  bool categoryHasRemaining(String category) {
                    final titles = wish[_norm(category)];
                    if (titles == null || titles.isEmpty) {
                      // Wishlist bilgisi yoksa emin olamıyoruz; gösterelim.
                      return true;
                    }
                    for (final t in titles) {
                      if (!ownedKeys.contains(keyOf(category, t))) return true;
                    }
                    return false;
                  }

                  final visibleCategories = <String>[
                    for (final c in allCategories)
                      if (categoryHasRemaining(c.title)) c.title,
                  ];

                  // Açılışta veya veri güncellenince: Seçili kategori görünür listede değilse
                  // (yani tamamlanmışsa veya artık mevcut değilse), ilk tamamlanmamış kategoriyi seç.
                  // Kullanıcı AddCategory görünümünü özellikle açtıysa (addCategorySelectionKey), dokunma.
                  if (_wishlistLoaded &&
                      dowryState is DowryListLoaded &&
                      selectCategoryState != addCategorySelectionKey &&
                      visibleCategories.isNotEmpty &&
                      !visibleCategories.contains(selectCategoryState)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        context.read<SelectCategoryCubit>().selectCategory(
                          visibleCategories.first,
                        );
                      }
                    });
                  }

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Leading + button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Artık modal yok, sayfa içinde AddCategoryView göstereceğiz
                            context.read<SelectCategoryCubit>().selectCategory(
                              addCategorySelectionKey,
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 14,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  context.loc.addCategoryButtonText,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Categories
                      ...visibleCategories.map((title) {
                        final isSelected = title == selectCategoryState;

                        // Label with item counts: always show remaining count => "Category (remaining)"
                        // Remaining = wishlist items not yet owned. If dowry not loaded, owned set is empty
                        // and remaining == total wishlist items in that category.
                        var displayLabel = title;
                        if (_wishlistLoaded) {
                          final titles = wish[_norm(title)];
                          if (titles != null && titles.isNotEmpty) {
                            var remaining = 0;
                            for (final t in titles) {
                              if (!ownedKeys.contains(keyOf(title, t))) {
                                remaining++;
                              }
                            }
                            displayLabel = '$title ($remaining)';
                          }
                        }
                        return CategoryButton(
                          categoryName: displayLabel,
                          isSelected: isSelected,
                          onPressed: () {
                            context.read<SelectCategoryCubit>().selectCategory(
                              title,
                            );
                          },
                        );
                      }),
                    ],
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  // Modal akışı kaldırıldı; AddCategoryView sayfası kullanılıyor.
}
