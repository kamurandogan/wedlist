import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        const SnackBar(content: Text('Doğrulama e-postası tekrar gönderildi.')),
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
        errorText = 'E-posta adresiniz henüz doğrulanmadı. Lütfen e-postanızı kontrol edin ve gelen linke tıklayın.';
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
              Text('Verification', style: Theme.of(context).textTheme.headlineLarge),
              Text(
                _userEmail != null
                    ? 'Lütfen $_userEmail adresine gönderilen doğrulama linkine tıklayın.'
                    : 'Please click the verification link sent to your email.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (_userEmail != null)
                TextButton(
                  onPressed: _resendVerificationEmail,
                  child: const Text('Tekrar Gönder'),
                ),
              const SizedBox(height: 40),
              if (errorText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(errorText!, style: const TextStyle(color: Colors.red)),
                ),
              CustomFilledButton(
                text: 'Doğrulamayı Kontrol Et',
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
