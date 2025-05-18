import 'package:shared_preferences/shared_preferences.dart';
import '../models/pelangganModel.dart';
import 'dart:convert';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  Pelanggan? _pelanggan;

  Future<void> setPelanggan(Pelanggan pelanggan) async {
    _pelanggan = pelanggan;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pelanggan', jsonEncode(pelanggan.toJson()));
  }

  Future<Pelanggan?> getPelanggan() async {
    if (_pelanggan != null) return _pelanggan;

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('pelanggan');

    if (data != null) {
      _pelanggan = Pelanggan.fromJson(jsonDecode(data));
    }
    return _pelanggan;
  }

  Future<void> clear() async {
    _pelanggan = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pelanggan');
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // atau hanya remove key tertentu jika tidak mau hapus semua
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('pelanggan');
  }
}
