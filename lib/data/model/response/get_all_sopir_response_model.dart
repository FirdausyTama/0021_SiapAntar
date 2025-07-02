import 'dart:convert';

class GetSopirById {
  final String message;
  final int statusCode;
  final GetSopir data;

  GetSopirById({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  GetSopirById copyWith({String? message, int? statusCode, GetSopir? data}) =>
      GetSopirById(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory GetSopirById.fromRawJson(String str) =>
      GetSopirById.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSopirById.fromJson(Map<String, dynamic> json) => GetSopirById(
    message: json["message"],
    statusCode: json["status_code"],
    data: GetSopir.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data.toJson(),
  };
}

class GetAllSopirModel {
  final String message;
  final int statusCode;
  final List<GetSopir> data;

  GetAllSopirModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  GetAllSopirModel copyWith({
    String? message,
    int? statusCode,
    List<GetSopir>? data,
  }) => GetAllSopirModel(
    message: message ?? this.message,
    statusCode: statusCode ?? this.statusCode,
    data: data ?? this.data,
  );

  factory GetAllSopirModel.fromRawJson(String str) =>
      GetAllSopirModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllSopirModel.fromJson(Map<String, dynamic> json) =>
      GetAllSopirModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<GetSopir>.from(
          json["data"].map((x) => GetSopir.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetSopir {
  final int id;
  final String namaSopir;
  final String noHp;
  final String? deskripsi;
  final String tipeMobil;
  final String? fotoSopir;
  final bool statusTersedia;
  final String? hargaPerHari;

  GetSopir({
    required this.id,
    required this.namaSopir,
    required this.noHp,
    required this.deskripsi,
    required this.tipeMobil,
    required this.fotoSopir,
    required this.statusTersedia,
    required this.hargaPerHari,
  });

  GetSopir copyWith({
    int? id,
    String? namaSopir,
    String? noHp,
    String? deskripsi,
    String? tipeMobil,
    String? fotoSopir,
    bool? statusTersedia,
    String? hargaPerHari,
  }) => GetSopir(
    id: id ?? this.id,
    namaSopir: namaSopir ?? this.namaSopir,
    noHp: noHp ?? this.noHp,
    deskripsi: deskripsi ?? this.deskripsi,
    tipeMobil: tipeMobil ?? this.tipeMobil,
    fotoSopir: fotoSopir ?? this.fotoSopir,
    statusTersedia: statusTersedia ?? this.statusTersedia,
    hargaPerHari: hargaPerHari ?? this.hargaPerHari,
  );

  factory GetSopir.fromRawJson(String str) =>
      GetSopir.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetSopir.fromJson(Map<String, dynamic> json) => GetSopir(
    id: json["id"],
    namaSopir: json["nama_sopir"],
    noHp: json["no_hp"],
    deskripsi: json["deskripsi"],
    tipeMobil: json["tipe_mobil"],
    fotoSopir: json["foto_sopir"],
    statusTersedia: json["status_tersedia"] ?? true,
    hargaPerHari: json["harga_per_hari"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_sopir": namaSopir,
    "no_hp": noHp,
    "deskripsi": deskripsi,
    "tipe_mobil": tipeMobil,
    "foto_sopir": fotoSopir,
    "status_tersedia": statusTersedia,
    "harga_per_hari": hargaPerHari,
  };
}