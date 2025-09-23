part of '../../main_page.dart';

class MyTabView extends StatelessWidget {
  const MyTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Padding(
        padding: AppPaddings.largeOnlyTop,
        child: TabBarView(
          children: [
            HomePage(),
            Center(child: Text('Beach')),
            Center(child: Text('Sun')),
          ],
        ),
      ),
    );
  }
}
