import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    required this.labelText,
    this.controller,
    this.validator,
    super.key,
  });

  final String labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(),
      ),
      keyboardType: labelText == 'Email' ? TextInputType.emailAddress : TextInputType.text,
      obscureText: labelText.contains('Şifre'),
    );
  }
}
