import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/announcementModel.dart';
import '../services/api_service.dart';

class AnnouncementController {
  // Ambil semua pengumuman
  Future<List<Announcement>> getAllAnnouncements() async {
    final response = await ApiService.get('announcements'); // FIXED: sesuaikan dengan backend

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'];

      return data.map((json) => Announcement.fromJson(json)).toList();
    } else {
      debugPrint('URL: ${Uri.parse('/api/announcements')}');
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Body: ${response.body}');
      throw Exception('Gagal mengambil data pengumuman');
    }
  }
}
