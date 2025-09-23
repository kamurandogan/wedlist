part of '../../login_page.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            context.go(AppRoute.register.path);
            // TODO(kamuran): Register sayfasına yönlendirme
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
          child: const Text(
            'Register Here',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
