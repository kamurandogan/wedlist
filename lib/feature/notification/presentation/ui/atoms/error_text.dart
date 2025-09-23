import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class ErrorText extends StatelessWidget {
  const ErrorText(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('${context.loc.errorPrefix} $message'));
  }
}
