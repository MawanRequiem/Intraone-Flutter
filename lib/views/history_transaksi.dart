import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaksiModel.dart';
import '../controllers/transaksiController.dart';
import '../utils/user_session.dart';
import '../models/pelangganModel.dart';
import 'home_page.dart';
import 'profile_page.dart';

class HistoryTransaksiPage extends StatefulWidget {
  const HistoryTransaksiPage({super.key});

  @override
  State<HistoryTransaksiPage> createState() => _HistoryTransaksiPageState();
}

class _HistoryTransaksiPageState extends State<HistoryTransaksiPage> {
  List<Transaksi> riwayat = [];
  bool loading = true;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchTransaksi();
  }

  void fetchTransaksi() async {
    final user = await UserSession().getPelanggan();
    if (user == null) return;

    final controller = TransaksiController();
    final result = await controller.getHistory(user.userId);

    setState(() {
      riwayat = result;
      loading = false;
    });
  }

  String formatTanggal(String raw) {
    try {
      final date = DateTime.parse(raw).toLocal();
      return DateFormat("d MMMM y HH.mm", 'id_ID').format(date) + ' WIB';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 140,
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
                    'Riwayat Transaksi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : riwayat.isEmpty
                      ? const Center(child: Text("Belum ada transaksi"))
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: riwayat.length,
                      itemBuilder: (context, index) {
                        final trx = riwayat[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _row("Tanggal", formatTanggal(trx.tanggal)),
                                _row("Paket", trx.paket),
                                _row("Total", trx.total),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
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
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
        },
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
