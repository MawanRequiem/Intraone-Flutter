import 'package:flutter/material.dart';
import 'package:mobile/views/batalkan_paket_page.dart';
import 'package:mobile/views/payment_method_page.dart';
import 'package:mobile/views/upgrade_page.dart';
import 'models/pelangganModel.dart';
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
            '/batalkan-paket': (context) => const BatalkanPaketPage(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/payment': (context) => const PaymentPage(),
            '/payment-method': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return PaymentMethodPage(
                  pelanggan: args['pelanggan'],
                  userId: args['userId'],
                  metode: args['metode'],
                  total: args['total'],
                  jenis: args['jenis']
              );
            },
            '/upgrade-page': (context) {
              final pelanggan = ModalRoute.of(context)!.settings.arguments as Pelanggan;
              return UpgradePage(pelanggan: pelanggan);
            },
          });
      },
    );
  }
}
