import 'dart:convert';

class SopirRequestModel {
  final String namaSopir;
  final String noHp;
  final String? deskripsi; // nullable
  final String tipeMobil;
  final String? fotoSopir; // nullable
  final bool statusTersedia;
  final String? hargaPerHari; // nullable

  SopirRequestModel({
    required this.namaSopir,
    required this.noHp,
    this.deskripsi, // nullable constructor param
    required this.tipeMobil,
    this.fotoSopir, // nullable constructor param
    required this.statusTersedia,
    this.hargaPerHari, // nullable constructor param
  });

  SopirRequestModel copyWith({
    String? namaSopir,
    String? noHp,
    String? deskripsi,
    String? tipeMobil,
    String? fotoSopir,
    bool? statusTersedia,
    String? hargaPerHari,
  }) => SopirRequestModel(
    namaSopir: namaSopir ?? this.namaSopir,
    noHp: noHp ?? this.noHp,
    deskripsi: deskripsi ?? this.deskripsi,
    tipeMobil: tipeMobil ?? this.tipeMobil,
    fotoSopir: fotoSopir ?? this.fotoSopir,
    statusTersedia: statusTersedia ?? this.statusTersedia,
    hargaPerHari: hargaPerHari ?? this.hargaPerHari,
  );

  factory SopirRequestModel.fromRawJson(String str) =>
      SopirRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SopirRequestModel.fromJson(Map<String, dynamic> json) =>
      SopirRequestModel(
        namaSopir: json["nama_sopir"],
        noHp: json["no_hp"],
        deskripsi: json["deskripsi"], // nullable, can be null
        tipeMobil: json["tipe_mobil"],
        fotoSopir: json["foto_sopir"], // nullable, can be null
        statusTersedia: json["status_tersedia"] ?? true,
        hargaPerHari: json["harga_per_hari"],
      );

  Map<String, dynamic> toJson() => {
    "nama_sopir": namaSopir,
    "no_hp": noHp,
    if (deskripsi != null) "deskripsi": deskripsi,
    "tipe_mobil": tipeMobil,
    if (fotoSopir != null) "foto_sopir": fotoSopir,
    "status_tersedia": statusTersedia,
    if (hargaPerHari != null) "harga_per_hari": hargaPerHari,
  };
}