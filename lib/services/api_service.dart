import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/transaksiModel.dart';

class ApiService {
  static Uri _buildUri(String endpoint) {
    return Uri.parse('${AppConstants.baseUrl}/$endpoint');
  }

  static Future<http.Response> get(String endpoint) async {
    try {
      final uri = _buildUri(endpoint);
      return await http.get(uri, headers: AppConstants.jsonHeaders);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = _buildUri(endpoint);
      return await http.post(
        uri,
        headers: AppConstants.jsonHeaders,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = _buildUri(endpoint);
      return await http.put(
        uri,
        headers: AppConstants.jsonHeaders,
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  static Future<http.Response> delete(String endpoint) async {
    try {
      final uri = _buildUri(endpoint);
      return await http.delete(uri, headers: AppConstants.jsonHeaders);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  static Future<bool> postTransaksi(Transaksi transaksi) async {
    try {
      final response = await post("transaksi/create", transaksi.toJson());
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Gagal menyimpan transaksi: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error kirimTransaksi: $e");
      return false;
    }
  }
}
