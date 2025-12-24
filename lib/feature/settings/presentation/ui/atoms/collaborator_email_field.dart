import 'package:flutter/material.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';

class CollaboratorEmailField extends StatefulWidget {
  const CollaboratorEmailField({
    required this.controller,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  State<CollaboratorEmailField> createState() => _CollaboratorEmailFieldState();
}

class _CollaboratorEmailFieldState extends State<CollaboratorEmailField> {
  String? _errorText;

  // Email regex validator
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Allow empty for optional field
    }

    final trimmed = value.trim();
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Geçerli bir email adresi giriniz';
    }

    return null;
  }

  void _handleSubmit(String value) {
    final error = _validateEmail(value);
    setState(() {
      _errorText = error;
    });

    if (error == null && widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: context.loc.collaboratorEmailLabel,
        errorText: _errorText,
      ),
      onChanged: (_) {
        // Clear error on change
        if (_errorText != null) {
          setState(() {
            _errorText = null;
          });
        }
      },
      onSubmitted: _handleSubmit,
    );
  }
}
