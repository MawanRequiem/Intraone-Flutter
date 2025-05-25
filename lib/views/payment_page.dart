import 'package:flutter/material.dart';
import '../models/pelangganModel.dart';

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
      Navigator.pop(context);
    }
  }

  void goToMetodePembayaran() {
    if (selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih metode pembayaran terlebih dahulu.")),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/payment-method',
      arguments: {
        'pelanggan' : pelanggan,
        'userId': pelanggan.userId,
        'metode': selectedMethod,
        'total': pelanggan.totalHarga,
        'jenis': jenisPembayaran
      },
    );
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
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(pelanggan.totalHarga, style: const TextStyle(fontWeight: FontWeight.bold)),
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
        buildPaymentCard('bca', 'BCA VA', 'lib/views/assets/partner6.png'),
        buildPaymentCard('mandiri', 'Mandiri VA', 'lib/views/assets/Mandiri.png'),
        buildPaymentCard('bni', 'BNI VA', 'lib/views/assets/Mandiri.png'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran Perpanjang")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Paket: ${pelanggan.paketInternet}"),
              Text("Durasi: ${pelanggan.durasiBerlangganan} bulan"),
              const Divider(height: 32),
              const Text("Pilih Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
              buildPaymentCard('gopay', 'GoPay', 'lib/views/assets/gopay.png'),
              buildPaymentCard('ovo', 'OVO', 'lib/views/assets/OVO.png'),
              buildPaymentCard('qris', 'QRIS', 'lib/views/assets/QRIS.png'),
              const SizedBox(height: 8),
              buildVAGroup(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: goToMetodePembayaran,
                child: const Text("Bayar Sekarang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}