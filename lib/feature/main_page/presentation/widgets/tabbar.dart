part of '../../main_page.dart';

class MyTabbar extends StatelessWidget {
  const MyTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.transparent,
      labelColor: AppColors.primary,
      dividerColor: Colors.transparent,
      unselectedLabelColor: AppColors.textColor.withValues(alpha: .7),
      tabs: const [
        Tab(text: 'Home'),
        Tab(text: 'Dowry'),
        Tab(text: 'Wish List'),
      ],
    );
  }
}
