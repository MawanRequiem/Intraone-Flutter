import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pelangganModel.dart';
import '../services/api_service.dart';

class PelangganController {
  // Fungsi login yang sebelumnya di service
  Future<Pelanggan?> login(String email, String noHP) async {
    final response = await ApiService.post('pelanggan/login', {
      'email': email,
      'noHP': noHP,
    });

    if (response.statusCode == 200) {
      final rawData = jsonDecode(response.body);
      final id = rawData['id'] ?? '';
      final data = rawData['data'] ?? {};
      return Pelanggan.fromJson({...data, 'userId': id});
    }
    return null;
  }

  // Fungsi dapat pelanggan berdasarkan ID
  Future<Pelanggan?> getPelanggan(String id) async {
    final response = await ApiService.get('pelanggan/$id');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Pelanggan.fromJson(data);
    }
    return null;
  }

  Future<bool> updateStatus(String userId, String status) async {
    final response = await ApiService.put(
      'pelanggan/$userId',
      { 'status': status },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Gagal update langganan: ${response.body}');
      return false;
    }
  }
}
