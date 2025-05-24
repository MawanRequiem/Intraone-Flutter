import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pelangganModel.dart';
import '../utils/user_session.dart';
import '../controllers/pelangganController.dart';
import 'home_page.dart';
import 'history_transaksi.dart';

class BatalkanPaketPage extends StatelessWidget {
  const BatalkanPaketPage({super.key});

  String formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate).toLocal();
      return '${DateFormat("d MMMM y 'pukul' HH.mm", 'id_ID').format(date)} WIB';
    } catch (e) {
      return rawDate;
    }
  }

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
                        'Konfirmasi Pembatalan Paket',
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
                            _infoBlock('Paket Internet:', pelanggan.paketInternet),
                            _infoBlock('Durasi:', '${pelanggan.durasiBerlangganan} bulan'),
                            _infoBlock('Total Harga:', pelanggan.totalHarga),
                            _infoBlock('Tenggat Waktu:', formatDate(pelanggan.expiryDate)),
                            const SizedBox(height: 32),
                            _batalkanButton(context, pelanggan),
                            const SizedBox(height: 12),
                            _tidakButton(context),
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _batalkanButton(BuildContext context, Pelanggan pelanggan) {
    return InkWell(
      onTap: () {
        final controller = TextEditingController();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Konfirmasi Nomor HP'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Masukkan nomor HP Anda',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final input = controller.text.trim();
                    if (input == pelanggan.noHP) {
                      final success = await PelangganController().updateStatus(pelanggan.userId, "Request Pembatalan");
                      if (success && context.mounted) {
                        Navigator.pop(context); // tutup dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Permintaan pembatalan berhasil dikirim.')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gagal mengirim permintaan pembatalan.')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nomor HP tidak cocok. Silakan coba lagi.')),
                      );
                    }
                  },
                  child: const Text('Kirim'),
                ),
              ],
            );
          },
        );
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
            'Ya, Batalkan Paket',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _tidakButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Tidak',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HistoryTransaksiPage()));
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
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
