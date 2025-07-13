import 'dart:convert';

class PemesananRequestModel {
  final String namaPenyewa;
  final String noHp;
  final String? deskripsi;
  final String alamatJemput;
  final String alamatAntar;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String? jamJemput;
  final String tipeMobil;
  final int sopirId;
  final String? totalHarga;

  PemesananRequestModel({
    required this.namaPenyewa,
    required this.noHp,
    this.deskripsi,
    required this.alamatJemput,
    required this.alamatAntar,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    this.jamJemput,
    required this.tipeMobil,
    required this.sopirId,
    this.totalHarga,
  });

  PemesananRequestModel copyWith({
    String? namaPenyewa,
    String? noHp,
    String? deskripsi,
    String? alamatJemput,
    String? alamatAntar,
    String? tanggalMulai,
    String? tanggalSelesai,
    String? jamJemput,
    String? tipeMobil,
    int? sopirId,
    String? totalHarga,
  }) => PemesananRequestModel(
    namaPenyewa: namaPenyewa ?? this.namaPenyewa,
    noHp: noHp ?? this.noHp,
    deskripsi: deskripsi ?? this.deskripsi,
    alamatJemput: alamatJemput ?? this.alamatJemput,
    alamatAntar: alamatAntar ?? this.alamatAntar,
    tanggalMulai: tanggalMulai ?? this.tanggalMulai,
    tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
    jamJemput: jamJemput ?? this.jamJemput,
    tipeMobil: tipeMobil ?? this.tipeMobil,
    sopirId: sopirId ?? this.sopirId,
    totalHarga: totalHarga ?? this.totalHarga,
  );

  factory PemesananRequestModel.fromRawJson(String str) =>
      PemesananRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PemesananRequestModel.fromJson(Map<String, dynamic> json) =>
      PemesananRequestModel(
        namaPenyewa: json["nama_penyewa"],
        noHp: json["no_hp"],
        deskripsi: json["deskripsi"],
        alamatJemput: json["alamat_jemput"],
        alamatAntar: json["alamat_antar"],
        tanggalMulai: json["tanggal_mulai"],
        tanggalSelesai: json["tanggal_selesai"],
        jamJemput: json["jam_jemput"],
        tipeMobil: json["tipe_mobil"],
        sopirId: json["sopir_id"],
        totalHarga: json["total_harga"],
      );

  Map<String, dynamic> toJson() => {
    "nama_penyewa": namaPenyewa,
    "no_hp": noHp,
    if (deskripsi != null) "deskripsi": deskripsi,
    "alamat_jemput": alamatJemput,
    "alamat_antar": alamatAntar,
    "tanggal_mulai": tanggalMulai,
    "tanggal_selesai": tanggalSelesai,
    if (jamJemput != null) "jam_jemput": jamJemput,
    "tipe_mobil": tipeMobil,
    "sopir_id": sopirId,
    if (totalHarga != null) "total_harga": totalHarga,
  };
}