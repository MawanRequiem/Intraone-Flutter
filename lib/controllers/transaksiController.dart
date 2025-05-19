import 'dart:convert';
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
}