part of '../pages/user_detail_line_page.dart';

class UserTitle extends StatelessWidget {
  const UserTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'User',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black87),
    );
  }
}
