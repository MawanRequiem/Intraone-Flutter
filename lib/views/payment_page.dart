import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pelangganModel.dart';
import '../models/transaksiModel.dart';
import '../services/api_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Pelanggan pelanggan;
  String? selectedMethod;
  String jenisPembayaran = 'perpanjang';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      pelanggan = args['pelanggan'];
      jenisPembayaran = args['jenis'] ?? 'perpanjang';
    } else {
      // Jika data pelanggan tidak ditemukan, kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  void handleBayar() async {
    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih metode pembayaran terlebih dahulu.")),
      );
      return;
    }

    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final transaksi = Transaksi(
      durasi: pelanggan.durasiBerlangganan,
      jenis: jenisPembayaran,
      metode: selectedMethod!,
      paket: pelanggan.paketInternet,
      tanggal: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      total: pelanggan.totalHarga.toString(),
      userId: pelanggan.userId,
    );

    final response = await ApiService.post('transaksi/create', transaksi.toJson());

    Navigator.of(context).pop(); // Tutup loading

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/confirm-success', arguments: {
        'paket': pelanggan.paketInternet,
        'metode': selectedMethod
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan transaksi.")),
      );
    }
  }

  Widget buildPaymentCard(String method, String label, String imagePath) {
    final isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade400,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, width: 32, height: 32),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const Spacer(),
            Text("Rp ${pelanggan.totalHarga}", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget buildVAGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Virtual Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        buildPaymentCard('bca', 'BCA Virtual Account', 'lib/views/assets/partner6.png'),
        buildPaymentCard('mandiri', 'Mandiri Virtual Account', 'lib/views/assets/Mandiri.png'),
        buildPaymentCard('bni', 'BNI Virtual Account', 'lib/views/assets/Mandiri.png'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Perpanjang"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Paket: ${pelanggan.paketInternet}", style: const TextStyle(fontSize: 16)),
              Text("Durasi: ${pelanggan.durasiBerlangganan} bulan", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              const Text("Pilih Metode Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              buildPaymentCard('gopay', 'Gopay', 'lib/views/assets/Gopay.png'),
              buildPaymentCard('ovo', 'OVO', 'lib/views/assets/OVO.png'),
              buildPaymentCard('qris', 'QRIS', 'lib/views/assets/QRIS.png'),
              const SizedBox(height: 12),
              buildVAGroup(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleBayar,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text("Bayar Sekarang", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
