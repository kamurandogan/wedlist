import 'package:flutter/material.dart';
import 'package:wedlist/feature/register/presentation/ui/register_textfield.dart';

class RegisterTextFormfield extends StatelessWidget {
  const RegisterTextFormfield({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordAgainController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordAgainController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RegisterTextField(
          labelText: 'Ad Soyad',
          controller: nameController,
          validator: (v) => v == null || v.isEmpty ? 'Ad Soyad giriniz' : null,
        ),
        RegisterTextField(
          labelText: 'Email',
          controller: emailController,
          validator: (v) => v == null || v.isEmpty ? 'Email giriniz' : null,
        ),
        RegisterTextField(
          labelText: 'Şifre',
          controller: passwordController,
          validator: (v) => v == null || v.isEmpty ? 'Şifre giriniz' : null,
        ),
        RegisterTextField(
          labelText: 'Şifre (Tekrar)',
          controller: passwordAgainController,
          validator: (v) => v == null || v.isEmpty ? 'Şifreyi tekrar giriniz' : null,
        ),
      ],
    );
  }
}
