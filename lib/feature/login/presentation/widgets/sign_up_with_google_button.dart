part of '../../login_page.dart';

class SignUpWithGoogleButton extends StatelessWidget {
  const SignUpWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          context.read<AuthBloc>().add(
            const AuthEvent.signInWithGoogleRequested(),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedGoogle,
              color: AppColors.textColor,
            ),
            const SizedBox(width: 16),
            Text(context.loc.signInWithGoogle),
          ],
        ),
      ),
    );
  }
}
