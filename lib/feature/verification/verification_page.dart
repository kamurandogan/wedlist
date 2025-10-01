import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/extensions/l10n_extension.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/utils/paddings.dart';
import 'package:wedlist/core/widgets/custom_filled_button/custom_filled_button.dart';

part 'presentation/widgets/digit_textfield.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String? get _userEmail => FirebaseAuth.instance.currentUser?.email;

  Future<void> _resendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.verificationEmailResent)),
      );
    }
  }

  String? errorText;

  Future<void> _validateAndSubmit() async {
    setState(() {
      errorText = null;
    });
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (!mounted) return;
    if (user != null && user.emailVerified) {
      context.go(AppRoute.main.path);
    } else {
      setState(() {
        errorText = context.loc.emailNotVerifiedYet;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPaddings.columnPadding,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.loc.verificationTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                _userEmail != null
                    ? context.loc.verificationInstructionWithEmail(_userEmail!)
                    : context.loc.verificationInstruction,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (_userEmail != null)
                TextButton(
                  onPressed: _resendVerificationEmail,
                  child: Text(context.loc.resendButton),
                ),
              const SizedBox(height: 40),
              if (errorText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              CustomFilledButton(
                text: context.loc.checkVerificationButton,
                onPressed: _validateAndSubmit,
                size: const Size(double.infinity, 56),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
