import 'package:flutter/material.dart';
import '../models/pelangganModel.dart';
import '../utils/user_session.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Pelanggan? pelanggan;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPelanggan();
  }

  void loadPelanggan() async {
    final data = await UserSession().getPelanggan();
    if (data == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        pelanggan = data;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat datang, ${pelanggan!.nama}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await UserSession().clear();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _infoTile('Email', pelanggan!.email),
            _infoTile('Nomor HP', pelanggan!.noHP),
            _infoTile('Paket Internet', pelanggan!.paketInternet),
            _infoTile('Status', pelanggan!.status),
            _infoTile('Tanggal Berlangganan', pelanggan!.subscriptionDate),
            _infoTile('Berakhir Pada', pelanggan!.expiryDate),
            _infoTile('Alamat', pelanggan!.alamat),
            _infoTile('Kota', pelanggan!.kota),
            _infoTile('Kecamatan', pelanggan!.kecamatan),
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
