class Transaksi {
  final int durasi;
  final String jenis;
  final String metode;
  final String paket;
  final String tanggal;
  final String total;
  final String userId;

  Transaksi({
    required this.durasi,
    required this.jenis,
    required this.metode,
    required this.paket,
    required this.tanggal,
    required this.total,
    required this.userId,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      durasi: json['durasi'] is int
          ? json['durasi']
          : int.tryParse(json['durasi'].toString()) ?? 0,
      jenis: json['jenis'] ?? '',
      metode: json['metode'] ?? '',
      paket: json['paket'] ?? '',
      tanggal: json['tanggal'] ?? '',
      total: json['total'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'durasi': durasi,
      'jenis': jenis,
      'metode': metode,
      'paket': paket,
      'tanggal': tanggal,
      'total': total,
      'userId': userId,
    };
  }
}