import 'package:flutter/material.dart';
import '../controllers/pelangganController.dart';
import '../utils/user_session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final noHpController = TextEditingController();
  final pelangganController = PelangganController();

  bool loading = false;
  String? error;

  void login() async {
    setState(() {
      loading = true;
      error = null;
    });

    final email = emailController.text.trim();
    final noHp = noHpController.text.trim();

    final pelanggan = await pelangganController.login(email, noHp);

    setState(() {
      loading = false;
    });

    if (pelanggan != null) {
      await UserSession().setPelanggan(pelanggan);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        error = 'Login gagal. Periksa email dan nomor HP.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noHpController,
              decoration: const InputDecoration(labelText: 'Nomor HP'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
