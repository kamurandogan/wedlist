import 'package:flutter/material.dart';

class ItemTextField extends StatelessWidget {
  const ItemTextField({
    required this.controller,
    required this.label,
    super.key,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
