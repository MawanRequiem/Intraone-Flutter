class AppConstants {
  // Gunakan 10.0.2.2 untuk Android emulator. Ubah sesuai environment.
  static const String baseUrl = 'http://10.0.2.2:9999/api';

  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
