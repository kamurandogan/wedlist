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
        Text(context.loc.dontHaveAccount),
        TextButton(
          onPressed: () {
            context.go(AppRoute.register.path);
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
          child: Text(
            context.loc.registerHere,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
