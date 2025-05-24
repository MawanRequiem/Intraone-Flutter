import 'package:flutter/material.dart';
import '../models/pelangganModel.dart';
import '../utils/user_session.dart';
import 'easter_egg_page.dart';
import 'home_page.dart';
import 'history_transaksi.dart';
int _janitraTapCount = 0;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pelanggan?>(
      future: UserSession().getPelanggan(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final pelanggan = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Gradient header
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF007BFF), Color(0xFF00C6A0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: const Text(
                        'Profil Pengguna',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                        child: ListView(
                          children: [
                        pelanggan.nama == 'Janitra Sutanto'
                        ? GestureDetector(
                            onTap: () {
                      _janitraTapCount++;
                      if (_janitraTapCount >= 5) {
                      _janitraTapCount = 0;
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EasterEggPage()));
                      }
                      },
                        child: _infoBlock('Nama:', pelanggan.nama),
                      )
                            : _infoBlock('Nama:', pelanggan.nama),
                            _infoBlock('Email:', pelanggan.email),
                            _infoBlock('Tempat, Tanggal Lahir:', '${pelanggan.tempatLahir}, ${pelanggan.tanggalLahir}'),
                            _infoBlock('No. KTP:', pelanggan.noKTP),
                            _infoBlock('Alamat:', pelanggan.alamat),
                            _infoBlock('Kota:', pelanggan.kota),
                            _infoBlock('Paket:', pelanggan.paketInternet),
                            const SizedBox(height: 32),
                            _logoutButton(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _bottomNavBar(context),
        );
      },
    );
  }

  Widget _infoBlock(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        await UserSession().clear();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Keluar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HistoryTransaksiPage()));
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF007BFF),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.refresh), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
