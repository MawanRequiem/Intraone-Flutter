import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/views/payment_method_page.dart';
import 'package:mobile/views/upgrade_page.dart';
import '../models/pelangganModel.dart';
import '../controllers/pelangganController.dart';
import '../utils/user_session.dart';
import 'profile_page.dart';
import 'history_transaksi.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Pelanggan? pelanggan;
  bool loading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      loadPelanggan();
    });
  }

  void loadPelanggan() async {
    final session = await UserSession().getPelanggan();
    if (session == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      final updated = await PelangganController().getPelanggan(session.userId); // ambil dari RTDB
      final withUserId = updated!.copyWithUserId(session.userId);
      if (!mounted) return;
      setState(() {
        pelanggan = withUserId ?? session; // fallback ke session kalau gagal
        loading = false;
      });
    }
  }


  Future<void> updateHalaman() async {
    final data = await pelangganController.getPelanggan(pelanggan!.userId);
    if (!mounted) return;

    if (data == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        pelanggan = data;
        loading = false;
      });
    }
  }

  void showPerpanjangConfirmation(BuildContext context, Pelanggan pelanggan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Perpanjang"),
          content: Text("Perpanjang paket ${pelanggan.paketInternet} selama ${pelanggan.durasiBerlangganan} bulan?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                print(pelanggan.toJson());
                Navigator.of(context).pop();
                Navigator.pushNamed(
                  context,
                  '/payment',
                  arguments: {
                    'jenis': 'perpanjang',
                    'pelanggan': pelanggan,
                  },
                );
              },
              child: const Text("Lanjut Bayar"),
            ),
          ],
        );
      },
    );
  }

  void showBatalkanConfirmation(BuildContext context, Pelanggan pelanggan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Pembatalan"),
          content: const Text("Apakah Anda yakin ingin membatalkan paket ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // tutup dialog
                Navigator.pushNamed(
                  context,
                  '/batalkan-paket',
                  arguments: pelanggan,
                ).then((result) {
                  if (result == true) {
                    loadPelanggan(); // refresh data
                  }
                });
              },
              child: const Text("Lanjutkan"),
            ),
          ],
        );
      },
    );
  }

  void showUpgradeConfirmation(BuildContext context, Pelanggan pelanggan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Upgrade"),
          content: const Text("Apakah Anda ingin mengubah paket langganan Anda?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // tutup dialog
                Navigator.pushNamed(
                  context,
                  '/upgrade-page',
                  arguments: pelanggan,
                ).then((result) {
                  if (result == true) {
                    loadPelanggan(); // refresh data
                  }
                });
              },
              child: const Text("Lanjutkan"),
            ),
          ],
        );
      },
    );
  }


  String formatTanggal(String rawDateTime) {
    final dateTime = DateTime.parse(rawDateTime).toLocal();
    final formatter = DateFormat("d MMMM yyyy 'pukul' HH.mm", 'id_ID');
    return '${formatter.format(dateTime)} WIB';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient header - mentok ke atas
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
                // Header text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Selamat Datang,\n${pelanggan!.nama}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: ListView(
                      children: [
                        _infoLine('Paket', pelanggan!.paketInternet, bold: true),
                        _infoLine('Durasi:', '${pelanggan!.durasiBerlangganan} bulan'),
                        _infoLine('Total Harga:', '${pelanggan!.totalHarga}'),
                        _infoLine('Tenggat Waktu:', '${formatTanggal(pelanggan!.expiryDate)}'),
                        _statusLine(pelanggan!.status),
                        const SizedBox(height: 24),
                        _gradientButton('Perpanjang Paket',
                          [Color(0xFF00C6A0), Color(0xFF00B894)],
                          onTap: () {
                            final pelanggan = this.pelanggan;
                            if (pelanggan != null) {

                              print(pelanggan.toJson());
                              showPerpanjangConfirmation(context, pelanggan!);
                            }
                          },),
                        const SizedBox(height: 12),
                        _gradientButton(
                            'Upgrade Paket',
                            [Color(0xFF00B4DB), Color(0xFF0083B0)],
                            onTap: () {
                              showUpgradeConfirmation(context, pelanggan!);
                            }
                        ),
                        const SizedBox(height: 12),
                        _gradientButton(
                          'Batalkan Paket',
                          [Color(0xFFFF512F), Color(0xFFDD2476)],
                          onTap: () {
                            showBatalkanConfirmation(context, pelanggan!);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _infoLine(String text, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style:  TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            )
          ),
        ],
      ),
    );
  }

  Widget _statusLine(String status) {
    final lowerStatus = status.toLowerCase();
    Color statusColor;

    if (lowerStatus == 'aktif') {
      statusColor = Colors.green;
    } else if (lowerStatus == 'pending') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }



  Widget _gradientButton(String label, List<Color> colors, {required Null Function() onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavBar() {
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