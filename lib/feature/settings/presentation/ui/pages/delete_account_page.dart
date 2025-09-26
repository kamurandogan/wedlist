import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wedlist/core/router/app_router.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _busy = false;
  String? _error;

  Future<void> _deleteAccount() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturumu bulunamadı');
      }

      // Kullanıcıya ait temel verileri sil (varsa). Burada ana doc'u siliyoruz.
      try {
        await firestore.collection('users').doc(user.uid).delete();
      } catch (_) {
        // Doc olmayabilir; sorun etme.
      }

      await user.delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hesabınız kalıcı olarak silindi.')),
      );
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      // requires-recent-login durumunu kullanıcıya bildir.
      if (e.code == 'requires-recent-login') {
        setState(() {
          _error = 'Güvenlik nedeniyle lütfen yeniden giriş yapın ve ardından hesabı silmeyi tekrar deneyin.';
        });
      } else {
        setState(() => _error = e.message);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesabı sil'),
        leading: _prevNavigationButton(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hesabınızı ve ilişkili verileri kalıcı olarak silmek üzeresiniz. Bu işlem geri alınamaz.',
            ),
            const SizedBox(height: 12),
            const Text(
              'Devam etmeden önce önemli verilerinizi dışa aktardığınızdan emin olun.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _busy ? null : _deleteAccount,
                    child: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Hesabımı kalıcı olarak sil'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _prevNavigationButton(BuildContext context) {
  return IconButton(
    icon: const BackButtonIcon(),
    onPressed: () {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoute.settings.path);
      }
    },
  );
}
