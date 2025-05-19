import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/controllers/pelangganController.dart';
import 'package:mobile/views/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/transaksiController.dart';
import '../models/transaksiModel.dart';
import '../utils/user_session.dart';
import 'home_page.dart';
final transaksiController = TransaksiController();
final pelangganController = PelangganController();

class PaymentMethodPage extends StatefulWidget {
  final String userId;
  final String metode;
  final String total;


  const PaymentMethodPage({
    super.key,
    required this.userId,
    required this.metode,
    required this.total,
  });

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  late Timer _timer;
  int _countdown = 900; // 15 menit = 900 detik
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
    final transaksi = Transaksi(
      durasi: 1, // sementara 1, bisa disesuaikan jika ada data durasi di args
      jenis: 'perpanjang',
      metode: widget.metode,
      paket: 'Paket Internet', // atau ambil dari argumen jika tersedia
      tanggal: DateTime.now().toIso8601String(),
      total: widget.total,
      userId: widget.userId,
    );


    final response = await transaksiController.postTransaksi(transaksi);
    if (response) {
      final okLangganan = await transaksiController.updateLangganan(
        widget.userId,
        transaksi.durasi,
      );
      if (!okLangganan) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaksi sudah dicatat, tapi gagal update masa langganan.")),
        );
        return;
      }
      setState(() {
        isConfirmed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pembayaran berhasil dikonfirmasi."))
      );
      Future.delayed(const Duration(seconds: 2), () async {
        final updatedPelanggan = await pelangganController.getPelanggan(widget.userId);
        if (updatedPelanggan != null) {
          UserSession().savePelanggan(updatedPelanggan);
        }
        Navigator.pushReplacementNamed(context, '/home');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan transaksi.")),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    final va = generateVA(widget.userId);

    Widget content;

    if (widget.metode == 'ovo') {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            const SizedBox(height: 24),
            Text("Sisa waktu pembayaran: ${getFormattedTime()}",
                style: const TextStyle(fontSize: 16, color: Colors.red)),
            const SizedBox(height: 20),
            if (!isConfirmed)
              ElevatedButton(
                onPressed: confirmPayment,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text("Konfirmasi Pembayaran"),
              )
            else
              const Text("Pembayaran telah dikonfirmasi!",
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
