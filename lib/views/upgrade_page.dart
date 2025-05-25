import 'package:flutter/material.dart';
import '../models/pelangganModel.dart';

class UpgradePage extends StatefulWidget {
  final Pelanggan pelanggan;

  const UpgradePage({Key? key, required this.pelanggan}) : super(key: key);

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  String? selectedPaket;
  int durasi = 1;

  final paketList = {
    '30 Mbps Basic': '150000',
    '70 Mbps Premium': '250000',
    '150 Mbps Ultra': '350000',
  };

  Widget _gradientButton(String label, List<Color> colors, VoidCallback? onTap, {bool disabled = false}) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: disabled
                ? [Colors.grey.shade400, Colors.grey.shade600]
                : colors,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handleLanjutPembayaran() {
    final hargaPaket = int.parse(paketList[selectedPaket!]!);
    final totalHarga = (hargaPaket * durasi).toString();

    final upgraded = Pelanggan(
      userId: widget.pelanggan.userId,
      alamat: widget.pelanggan.alamat,
      biayaAdmin: '5000',
      durasiBerlangganan: durasi,
      email: widget.pelanggan.email,
      expiryDate: widget.pelanggan.expiryDate,
      hargaPaket: hargaPaket.toString(),
      kategoriPaket: selectedPaket!,
      kecamatan: widget.pelanggan.kecamatan,
      kota: widget.pelanggan.kota,
      nama: widget.pelanggan.nama,
      noHP: widget.pelanggan.noHP,
      noHPAlternatif: widget.pelanggan.noHPAlternatif,
      noKTP: widget.pelanggan.noKTP,
      noTeleponRumah: widget.pelanggan.noTeleponRumah,
      paketInternet: selectedPaket!,
      ppn: '0',
      status: widget.pelanggan.status,
      subscriptionDate: widget.pelanggan.subscriptionDate,
      tanggalLahir: widget.pelanggan.tanggalLahir,
      tempatLahir: widget.pelanggan.tempatLahir,
      totalHarga: totalHarga,
    );

    Navigator.pushNamed(
      context,
      '/payment',
      arguments: {
        'jenis': 'upgrade',
        'pelanggan': upgraded,
      },
    );
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
                  child: const Text(
                    'Upgrade Paket',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView(
                      children: [
                        const Text(
                          "Pilih Paket Baru",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...paketList.entries.map((entry) {
                          final isSelected = selectedPaket == entry.key;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey.shade400,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected ? Colors.blue.shade50 : Colors.white,
                            ),
                            child: ListTile(
                              title: Text(entry.key),
                              subtitle: Text("Rp ${entry.value}/bulan"),
                              onTap: () => setState(() => selectedPaket = entry.key),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        const Text("Durasi Langganan", style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(onPressed: () => setState(() => durasi = (durasi - 1).clamp(1, 12)), icon: const Icon(Icons.remove)),
                            Text("$durasi bulan"),
                            IconButton(onPressed: () => setState(() => durasi++), icon: const Icon(Icons.add)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _gradientButton(
                          'Lanjut ke Pembayaran',
                          [Color(0xFF00C6A0), Color(0xFF00B894)],
                          _handleLanjutPembayaran,
                          disabled: selectedPaket == null,
                        ),
                        const SizedBox(height: 12),
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