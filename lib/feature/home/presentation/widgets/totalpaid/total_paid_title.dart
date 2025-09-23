import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class TotalPaidTitle extends StatelessWidget {
  const TotalPaidTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.loc.totalPaidTitle,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
