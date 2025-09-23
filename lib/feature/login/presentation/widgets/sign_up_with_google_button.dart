part of '../../login_page.dart';

class SignUpWithGoogleButton extends StatelessWidget {
  const SignUpWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedGoogle,
              color: AppColors.textColor,
            ),
            SizedBox(width: 16),
            Text(
              'Google ile Giriş Yap',
            ),
          ],
        ),
      ),
    );
  }
}
