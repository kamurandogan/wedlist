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
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          onPressed: () {
            context.read<AuthBloc>().add(SignInWithAppleRequested());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.apple, color: AppColors.textColor),
              const SizedBox(width: 12),
              Text(context.loc.signInWithApple),
            ],
          ),
        ),
      ),
    );
  }
}
