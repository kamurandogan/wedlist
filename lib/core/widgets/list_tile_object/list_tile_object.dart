import 'package:flutter/material.dart';
import 'package:wedlist/core/widgets/list_tile_object/list_tile_leading_icon.dart';

class ListTileObject extends StatelessWidget {
  const ListTileObject({required this.title, required this.date, super.key});

  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const ListTileLeadingIcon(),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(
        '₺ 1000',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: Colors.green),
      ),
    );
  }
}
