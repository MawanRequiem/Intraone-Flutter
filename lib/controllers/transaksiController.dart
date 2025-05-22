import 'dart:convert';
import 'package:http/http.dart';
import '../models/transaksiModel.dart';
import '../services/api_service.dart';

class TransaksiController {
  Future<List<Transaksi>> getHistory(String userId) async {
    final response = await ApiService.get('transaksi/$userId');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Transaksi.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> postTransaksi(Transaksi transaksi) async {
    final response = await ApiService.post('transaksi', transaksi.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print(transaksi.toJson());
      print('Gagal menyimpan transaksi: ${response.body}');
      return false;
    }
  }

  Future<bool> updateLangganan(String userId, int durasi) async {
    final response = await ApiService.put(
      'pelanggan/$userId/langganan',
      { 'durasi': durasi },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal update langganan: ${response.body}');
      return false;
    }
  }
}