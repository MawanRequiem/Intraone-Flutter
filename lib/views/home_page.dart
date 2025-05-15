import 'package:flutter/material.dart';
import '../models/pelangganModel.dart';

class HomePage extends StatelessWidget {
  final Pelanggan pelanggan;

  const HomePage({super.key, required this.pelanggan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat datang, ${pelanggan.nama}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _infoTile('Email', pelanggan.email),
            _infoTile('Nomor HP', pelanggan.noHP),
            _infoTile('Paket', pelanggan.paketInternet),
            _infoTile('Status', pelanggan.status),
            _infoTile('Tanggal Berlangganan', pelanggan.subscriptionDate),
            _infoTile('Berakhir Pada', pelanggan.expiryDate),
            _infoTile('Alamat', pelanggan.alamat),
            _infoTile('Kota', pelanggan.kota),
            _infoTile('Kecamatan', pelanggan.kecamatan),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(value.isNotEmpty ? value : 'Tidak tersedia'),
      ),
    );
  }
}
