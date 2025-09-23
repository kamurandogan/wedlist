part of '../../main_page.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(10);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 10,
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: AppColors.primary),
    );
  }
}
