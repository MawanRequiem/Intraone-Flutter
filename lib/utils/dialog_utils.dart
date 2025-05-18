import 'package:flutter/material.dart';
import '../models/pelangganModel.dart';

void showPerpanjangConfirmation(BuildContext context, Pelanggan pelanggan) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Konfirmasi Perpanjang"),
        content: Text("Apakah Anda ingin memperpanjang paket ${pelanggan.paketInternet} selama ${pelanggan.durasiBerlangganan} bulan?"),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text("Lanjut Bayar"),
            onPressed: () {
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
          ),
        ],
      );
    },
  );
}
