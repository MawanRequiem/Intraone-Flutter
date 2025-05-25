import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/controllers/pelangganController.dart';
import 'package:mobile/views/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/transaksiController.dart';
import '../models/pelangganModel.dart';
import '../models/transaksiModel.dart';
import '../utils/user_session.dart';

final transaksiController = TransaksiController();
final pelangganController = PelangganController();

class PaymentMethodPage extends StatefulWidget {
  final Pelanggan pelanggan;
  final String userId;
  final String metode;
  final String total;
  final String jenis;

  const PaymentMethodPage({
    super.key,
    required this.pelanggan,
    required this.userId,
    required this.metode,
    required this.total,
    required this.jenis,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  late Timer _timer;
  int _countdown = 900;
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getFormattedTime() {
    final minutes = (_countdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (_countdown % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String generateVA(String userId) {
    final hash = userId.hashCode.abs();
    return '12345${hash.toString().padLeft(10, '0')}';
  }

  Future<void> openOvoApp() async {
    const ovoScheme = 'ovo://';
    if (await canLaunchUrl(Uri.parse(ovoScheme))) {
      await launchUrl(Uri.parse(ovoScheme));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membuka aplikasi OVO.")),
      );
    }
  }

  Future<void> confirmPayment() async {
    final pelanggan = widget.pelanggan;

    final transaksi = Transaksi(
      durasi: pelanggan.durasiBerlangganan,
      jenis: widget.jenis,
      metode: widget.metode,
      paket: pelanggan.paketInternet,
      tanggal: DateTime.now().toIso8601String(),
      total: widget.total,
      userId: pelanggan.userId,
    );

    print(transaksi.toJson());
    final success = await transaksiController.postTransaksi(transaksi);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan transaksi.")),
      );
      return;
    }

    // Update data pelanggan: paket, harga, total
    final updateData = {
      'paketInternet': pelanggan.paketInternet,
      'kategoriPaket': pelanggan.kategoriPaket,
      'hargaPaket': pelanggan.hargaPaket,
      'totalHarga': pelanggan.totalHarga,
    };

    final updateSuccess = await pelangganController.updatePelanggan(pelanggan.userId, updateData);
    if (!updateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaksi dicatat, tapi gagal update data pelanggan.")),
      );
      return;
    }

    // Update durasi/expiryDate
    final okLangganan = await transaksiController.updateLangganan(
      pelanggan.userId,
      transaksi.durasi,
    );
    if (!okLangganan) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaksi dicatat, tapi gagal update masa langganan.")),
      );
      return;
    }

    setState(() => isConfirmed = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pembayaran berhasil dikonfirmasi.")),
    );

    // Simpan kembali ke session
    Future.delayed(const Duration(seconds: 2), () async {
      final updatedPelanggan = await pelangganController.getPelanggan(pelanggan.userId);
      if (updatedPelanggan != null) {
        final withUserId = updatedPelanggan.copyWithUserId(pelanggan.userId);
        await UserSession().setPelanggan(withUserId);
      }
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final va = generateVA(widget.pelanggan.userId);

    final metode = widget.metode.toLowerCase();


    Widget content;

    if (metode == 'qris' || metode == 'gopay') {
      content = Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Image.asset(
              'assets/images/QRcode.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              "Total: ${widget.total}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          Text("Total: ${widget.total}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: openOvoApp,
            icon: const Icon(Icons.open_in_new),
            label: const Text("Lanjutkan ke Aplikasi OVO"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          ),
        ],
      );
    } else if (widget.metode == 'qris' || widget.metode == 'gopay') {
      content = Column(
        children: [
          Text("Total: ${widget.total}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/qris_placeholder.png',
            height: 200,
            fit: BoxFit.contain,
          ),
        ],
      );
    } else {
      content = Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Virtual Account Anda",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Center(
            child: SelectableText(
              va,
              style: const TextStyle(fontSize: 22, letterSpacing: 2),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              "Total: ${widget.total}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          Text("Total: ${widget.total}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Virtual Account Anda:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          SelectableText(
            va,
            style: const TextStyle(fontSize: 20, letterSpacing: 2),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient Header
          Container(
            height: 100,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar style
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Metode Pembayaran",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Konten putih
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        content,
                        const SizedBox(height: 24),
                        Text(
                          "Sisa waktu pembayaran: ${getFormattedTime()}",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        if (!isConfirmed)
                          SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: confirmPayment,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF007BFF), Color(0xFF00C6A0)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Konfirmasi Pembayaran",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          const Text(
                            "Pembayaran telah dikonfirmasi!",
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}