part of '../../login_page.dart';

class SignInWithAppleButton extends StatelessWidget {
  const SignInWithAppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: apple.SignInWithAppleButton(
          style: apple.SignInWithAppleButtonStyle.white,
          borderRadius: BorderRadius.zero,
          onPressed: () {
            context.read<AuthBloc>().add(SignInWithAppleRequested());
          },
        ),
      ),
    );
  }
}
