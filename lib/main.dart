import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'views/payment_page.dart';
import 'utils/user_session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _clearSessionOnStart() async {
    await UserSession().clearSession(); // Paksa hapus sesi saat app start
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _clearSessionOnStart(), // hapus sesi login saat start
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp(
          title: 'IntraOne App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const LoginPage(), // Selalu mulai dari login
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/payment': (context) => const PaymentPage(),
            // '/confirm-success': (context) => const ConfirmSuccessPage(), // kalau sudah ada
          },
        );
      },
    );
  }
}
