import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/feature/register/presentation/blocs/register_bloc.dart';
import 'package:wedlist/feature/register/presentation/ui/organisms/register_form.dart';
import 'package:wedlist/feature/register/presentation/ui/templates/register_template.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.go(AppRoute.verification.path);
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: const RegisterTemplate(
        title: 'Register Page',
        child: RegisterForm(),
      ),
    );
  }
}
