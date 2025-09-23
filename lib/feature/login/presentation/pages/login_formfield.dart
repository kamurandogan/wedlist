part of '../../login_page.dart';

class LoginFormField extends StatelessWidget {
  const LoginFormField({
    required this.emailController,
    required this.passwordController,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Email',

            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Şifre',
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
          ),
          obscureText: true,
          onFieldSubmitted: (_) {
            // Done'a basınca klavyeyi kapat ve giriş isteğini gönder.
            FocusScope.of(context).unfocus();
            context.read<AuthBloc>().add(
              SignInRequested(emailController.text, passwordController.text),
            );
          },
        ),
      ],
    );
  }
}
