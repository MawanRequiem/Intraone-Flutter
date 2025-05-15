import 'package:flutter/material.dart';
import '../controllers/pelangganController.dart';
import '../models/pelangganModel.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHPController = TextEditingController();
  final PelangganController _controller = PelangganController();

  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = emailController.text.trim();
    final noHp = noHPController.text.trim();

    if (email.isEmpty || noHp.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Email dan No HP wajib diisi";
      });
      return;
    }

    final pelanggan = await _controller.login(email, noHp);

    setState(() {
      _isLoading = false;
    });

    if (pelanggan != null) {
      // Jika login berhasil
      print('DATA LOGIN BERHASIL: ${pelanggan.toJson()}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(pelanggan: pelanggan),
        ),
      );
    } else {
      // Gagal login
      setState(() {
        _errorMessage = "Login gagal. Periksa kembali email dan nomor HP.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noHPController,
              decoration: const InputDecoration(labelText: "Nomor HP"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _handleLogin,
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
