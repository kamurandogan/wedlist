import 'package:flutter/material.dart';
import 'package:wedlist/core/utils/colors.dart';

class ListTileLeadingIcon extends StatelessWidget {
  const ListTileLeadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.02,
      height: size.width * 0.02,
      decoration: BoxDecoration(
        color: AppColors.accent,
        border: Border.all(color: AppColors.textColor, width: 2),
      ),
    );
  }
}
