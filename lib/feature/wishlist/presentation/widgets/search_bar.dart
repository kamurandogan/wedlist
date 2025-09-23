part of '../../wishlist_page.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppPaddings.mediumOnlyTop,
      child: SearchBar(
        shadowColor: WidgetStatePropertyAll<Color>(Colors.transparent),
        overlayColor: WidgetStatePropertyAll(Colors.white),
        hintText: 'Search',
        surfaceTintColor: WidgetStatePropertyAll(Colors.white),
        leading: HugeIcon(
          icon: HugeIcons.strokeRoundedSearch01,
          color: AppColors.primary,
        ),
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        elevation: WidgetStatePropertyAll<double>(0),
      ),
    );
  }
}
