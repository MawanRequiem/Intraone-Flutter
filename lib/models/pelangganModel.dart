class Pelanggan {
  final String userId;
  final String alamat;
  final String biayaAdmin;
  final int durasiBerlangganan;
  final String email;
  final String expiryDate;
  final String hargaPaket;
  final String kategoriPaket;
  final String kecamatan;
  final String kota;
  final String nama;
  final String noHP;
  final String noHPAlternatif;
  final String noKTP;
  final String noTeleponRumah;
  final String paketInternet;
  final String ppn;
  final String status;
  final String subscriptionDate;
  final String tanggalLahir;
  final String tempatLahir;
  final String totalHarga;

  Pelanggan({
    required this.userId,
    required this.alamat,
    required this.biayaAdmin,
    required this.durasiBerlangganan,
    required this.email,
    required this.expiryDate,
    required this.hargaPaket,
    required this.kategoriPaket,
    required this.kecamatan,
    required this.kota,
    required this.nama,
    required this.noHP,
    required this.noHPAlternatif,
    required this.noKTP,
    required this.noTeleponRumah,
    required this.paketInternet,
    required this.ppn,
    required this.status,
    required this.subscriptionDate,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.totalHarga,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      userId: json['userId'] ?? '',
      alamat: json['alamat'] ?? '',
      biayaAdmin: json['biayaAdmin'] ?? '',
      durasiBerlangganan: json['durasiBerlangganan'] is int
          ? json['durasiBerlangganan']
          : int.tryParse(json['durasiBerlangganan'].toString()) ?? 0,
      email: json['email'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      hargaPaket: json['hargaPaket'] ?? '',
      kategoriPaket: json['kategoriPaket'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      kota: json['kota'] ?? '',
      nama: json['nama'] ?? '',
      noHP: json['noHP'] ?? '',
      noHPAlternatif: json['noHPAlternatif'] ?? '',
      noKTP: json['noKTP'] ?? '',
      noTeleponRumah: json['noTeleponRumah'] ?? '',
      paketInternet: json['paketInternet'] ?? '',
      ppn: json['ppn'] ?? '',
      status: json['status'] ?? '',
      subscriptionDate: json['subscriptionDate'] ?? '',
      tanggalLahir: json['tanggalLahir'] ?? '',
      tempatLahir: json['tempatLahir'] ?? '',
      totalHarga: json['totalHarga'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'alamat': alamat,
      'biayaAdmin': biayaAdmin,
      'durasiBerlangganan': durasiBerlangganan,
      'email': email,
      'expiryDate': expiryDate,
      'hargaPaket': hargaPaket,
      'kategoriPaket': kategoriPaket,
      'kecamatan': kecamatan,
      'kota': kota,
      'nama': nama,
      'noHP': noHP,
      'noHPAlternatif': noHPAlternatif,
      'noKTP': noKTP,
      'noTeleponRumah': noTeleponRumah,
      'paketInternet': paketInternet,
      'ppn': ppn,
      'status': status,
      'subscriptionDate': subscriptionDate,
      'tanggalLahir': tanggalLahir,
      'tempatLahir': tempatLahir,
      'totalHarga': totalHarga,
    };
  }

  Pelanggan copyWithUserId(String newUserId) {
    return Pelanggan(
      userId: newUserId,
      alamat: alamat,
      biayaAdmin: biayaAdmin,
      durasiBerlangganan: durasiBerlangganan,
      email: email,
      expiryDate: expiryDate,
      hargaPaket: hargaPaket,
      kategoriPaket: kategoriPaket,
      kecamatan: kecamatan,
      kota: kota,
      nama: nama,
      noHP: noHP,
      noHPAlternatif: noHPAlternatif,
      noKTP: noKTP,
      noTeleponRumah: noTeleponRumah,
      paketInternet: paketInternet,
      ppn: ppn,
      status: status,
      subscriptionDate: subscriptionDate,
      tanggalLahir: tanggalLahir,
      tempatLahir: tempatLahir,
      totalHarga: totalHarga,
    );
  }
}
