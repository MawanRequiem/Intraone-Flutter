import 'package:flutter/material.dart';

class EasterEggPage extends StatelessWidget {
  const EasterEggPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎉 Selamat Ulang Tahun ke 24! 🎂',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset('lib/views/assets/birthday_cake.png', height: 200),
            const SizedBox(height: 20),
            const Text(
              'Semoga hari kamu penuh kebahagiaan dan bintang yang terang di malam hari!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
