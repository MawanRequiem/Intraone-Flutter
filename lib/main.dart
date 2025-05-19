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

  Future<Widget> _getInitialPage() async {
    final isLoggedIn = await UserSession().isLoggedIn();
    return isLoggedIn ? const HomePage() : const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getInitialPage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp(
          title: 'IntraOne App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: snapshot.data,
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
