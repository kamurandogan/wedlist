import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/utils/colors.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/core/widgets/custom_filled_button/custom_filled_button.dart';
import 'package:wedlist/feature/login/presentation/blocs/auth_bloc.dart';

part 'presentation/pages/login_formfield.dart';
part 'presentation/widgets/register_button.dart';
part 'presentation/widgets/sign_in_with_apple_button.dart';
part 'presentation/widgets/sign_up_with_google_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: AppPaddings.columnPadding,
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go(AppRoute.main.path);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.loc.loginTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              LoginFormField(
                emailController: emailController,
                passwordController: passwordController,
              ),
              const SizedBox(height: 16),
              const RegisterButton(),
              const SizedBox(height: 48),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  Widget? errorWidget;
                  if (state is AuthFailure) {
                    errorWidget = Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      if (state is AuthLoading) ...[
                        const CircularProgressIndicator(),
                      ] else ...[
                        if (errorWidget != null) errorWidget,
                        CustomFilledButton(
                          size: Size(size.width, 50),
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              SignInRequested(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                          },
                          text: context.loc.signInButtonText,
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              if (Platform.isIOS)
              const SignInWithAppleButton(),
              const SizedBox(height: 12),
              const SignUpWithGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }
}
