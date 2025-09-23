import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wedlist/core/router/app_router.dart';
import 'package:wedlist/core/widgets/custom_filled_button/custom_filled_button.dart';
import 'package:wedlist/feature/main_page/presentation/pages/user_detail_line_page.dart';
import 'package:wedlist/feature/register/domain/entities/register_entity.dart';
import 'package:wedlist/feature/register/presentation/blocs/register_bloc.dart';
import 'package:wedlist/feature/register/presentation/ui/register_text_formfield.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _weddingDate;
  Uint8List? _avatarBytes;

  @override
  void initState() {
    super.initState();
    if (_weddingDate != null) {
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      final formatter = DateFormat.yMMMMd(locale.toString());
      _dateController.text = formatter.format(_weddingDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _passwordAgainController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Şifreler eşleşmiyor.')));
        return;
      }
      final entity = RegisterEntity(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        weddingDate: _weddingDate,
        avatarBytes: _avatarBytes,
      );
      context.read<RegisterBloc>().add(RegisterSubmitted(entity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () async {
              try {
                final picker = ImagePicker();
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 512,
                  maxHeight: 512,
                );
                if (file != null) {
                  final bytes = await file.readAsBytes();
                  setState(() => _avatarBytes = bytes);
                }
              } on Exception catch (e) {
                // ignore: avoid_print
                print('Avatar seçilemedi: $e');
              }
            },
            child: CustomAvatar(
              radius: 120,
              showOverlay: _avatarBytes == null,
              overlayText: 'Avatarı değiştir',
              imageProvider: _avatarBytes != null
                  ? MemoryImage(_avatarBytes!)
                  : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
            ),
          ),
          RegisterTextFormfield(
            nameController: _nameController,
            emailController: _emailController,
            passwordController: _passwordController,
            passwordAgainController: _passwordAgainController,
          ),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Tarih seçiniz',
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(),
            ),
            onTap: () async {
              final now = DateTime.now();
              final locale = Localizations.localeOf(context);
              final formatter = DateFormat.yMMMMd(locale.toString());
              final picked = await showDatePicker(
                context: context,
                initialDate: _weddingDate ?? now,
                firstDate: DateTime(now.year - 1),
                lastDate: DateTime(now.year + 5),
              );
              if (picked != null) {
                setState(() => _weddingDate = picked);
                _dateController.text = formatter.format(picked);
              }
            },
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Düğün tarihi gerekli';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              if (state is RegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is RegisterFailure) {
                if (state.message.toLowerCase().contains('şifre') ||
                    state.message.toLowerCase().contains('password')) {
                  return CustomFilledButton(
                    text: 'Register',
                    onPressed: _submit,
                  );
                } else {
                  return CustomFilledButton(
                    text: 'Girişe Dön',
                    onPressed: () => context.go(AppRoute.login.path),
                  );
                }
              }
              return CustomFilledButton(
                text: 'Register',
                onPressed: _submit,
              );
            },
          ),
        ],
      ),
    );
  }
}
