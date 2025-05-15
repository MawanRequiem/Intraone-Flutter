import 'dart:convert';
import '../models/pelangganModel.dart';
import '../services/api_service.dart';

class PelangganController {
  Future<Pelanggan?> login(String email, String noHP) async {
    try {
      final response = await ApiService.post('pelanggan/login', {
        'email': email,
        'noHP': noHP,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Pelanggan.fromJson(data);
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<Pelanggan?> getPelanggan(String id) async {
    try {
      final response = await ApiService.get('pelanggan/$id');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('RESPON JSON: $data'); // Tambahkan ini
        return Pelanggan.fromJson(data);
      } else {
        print('Failed to fetch pelanggan data with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get pelanggan error: $e');
      return null;
    }
  }
}
