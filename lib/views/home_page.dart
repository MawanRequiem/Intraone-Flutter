import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/views/payment_method_page.dart';
import 'package:mobile/views/upgrade_page.dart';
import '../models/pelangganModel.dart';
import '../controllers/pelangganController.dart';
import '../models/announcementModel.dart';
import '../controllers/announcementController.dart';
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
  Future<List<Announcement>>? _announcementFuture;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      loadPelanggan();
      _announcementFuture = AnnouncementController().getAllAnnouncements();
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

  Future<void> refreshAnnouncements() async {
    setState(() {
      loadPelanggan();
      _announcementFuture = AnnouncementController().getAllAnnouncements();
    });
  }

  // Helper method to check if user can perform actions
  bool _canPerformActions() {
    return pelanggan?.status.toLowerCase() != 'pending';
  }

  void _showPendingStatusMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tidak dapat melakukan aksi ini karena status paket Anda masih pending.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void showPerpanjangConfirmation(BuildContext context, Pelanggan pelanggan) {
    if (!_canPerformActions()) {
      _showPendingStatusMessage();
      return;
    }

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
    if (!_canPerformActions()) {
      _showPendingStatusMessage();
      return;
    }

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

    final isPending = pelanggan?.status.toLowerCase() == 'pending';

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
                    child: RefreshIndicator(
                      onRefresh: refreshAnnouncements,
                      child: ListView(
                        children: [
                          _infoLine('Paket', pelanggan!.paketInternet, bold: true),
                          _infoLine('Durasi:', '${pelanggan!.durasiBerlangganan} bulan'),
                          _infoLine('Total Harga:', '${pelanggan!.totalHarga}'),
                          _infoLine('Tenggat Waktu:', '${formatTanggal(pelanggan!.expiryDate)}'),
                          _statusLine(pelanggan!.status),
                          const SizedBox(height: 24),

                          // Show warning message if status is pending
                          if (isPending)
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                border: Border.all(color: Colors.orange.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Paket Anda sedang dalam status pending. Anda tidak dapat melakukan perpanjang atau upgrade saat ini.',
                                      style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          _gradientButton('Perpanjang Paket',
                            isPending
                                ? [Colors.grey.shade400, Colors.grey.shade500]
                                : [Color(0xFF00C6A0), Color(0xFF00B894)],
                            isEnabled: !isPending,
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
                              isPending
                                  ? [Colors.grey.shade400, Colors.grey.shade500]
                                  : [Color(0xFF00B4DB), Color(0xFF0083B0)],
                              isEnabled: !isPending,
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
                          const SizedBox(height: 32),

                          const Text(
                            'Pengumuman',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder<List<Announcement>>(
                            future: _announcementFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('Tidak ada pengumuman.');
                              } else {
                                // FILTER hanya yang aktif
                                final announcements = snapshot.data!
                                    .where((a) => a.statusAnnouncement?.toLowerCase() == 'aktif')
                                    .toList();

                                if (announcements.isEmpty) {
                                  return const Text('Tidak ada pengumuman aktif.');
                                }

                                return Column(
                                  children: announcements.map((a) {
                                    return Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: Card(
                                        elevation: 0,
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
                                              Text(
                                                a.title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF007BFF),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                a.content,
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );

                              }
                            },
                          ),

                        ],
                      ),
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

  Widget _gradientButton(String label, List<Color> colors, {required VoidCallback onTap, bool isEnabled = true}) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
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
            style: TextStyle(
              color: isEnabled ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
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