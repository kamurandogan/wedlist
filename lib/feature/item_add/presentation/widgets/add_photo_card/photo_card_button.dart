import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class PhotoCardButton extends StatelessWidget {
  const PhotoCardButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: FilledButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Text(
          context.loc.addPhotoButtonText,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
