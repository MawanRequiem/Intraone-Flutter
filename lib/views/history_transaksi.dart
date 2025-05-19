import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaksiModel.dart';
import '../controllers/transaksiController.dart';
import '../utils/user_session.dart';
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
                  margin: const EdgeInsets.only(bottom: 40),
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
                          elevation: 0,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.black12),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _row("Tanggal", formatTanggal(trx.tanggal)),
                                _row("Jenis Transaksi", trx.jenis),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF007BFF), // BIRU sesuai gradient header
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
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
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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
