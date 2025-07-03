import 'dart:convert';

class GetPemesananById {
  final String message;
  final int statusCode;
  final GetPemesanan data;

  GetPemesananById({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  GetPemesananById copyWith({String? message, int? statusCode, GetPemesanan? data}) =>
      GetPemesananById(
        message: message ?? this.message,
        statusCode: statusCode ?? this.statusCode,
        data: data ?? this.data,
      );

  factory GetPemesananById.fromRawJson(String str) =>
      GetPemesananById.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPemesananById.fromJson(Map<String, dynamic> json) => GetPemesananById(
    message: json["message"],
    statusCode: json["status_code"],
    data: GetPemesanan.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": data.toJson(),
  };
}

class GetAllPemesananModel {
  final String message;
  final int statusCode;
  final List<GetPemesanan> data;

  GetAllPemesananModel({
    required this.message,
    required this.statusCode,
    required this.data,
  });

  GetAllPemesananModel copyWith({
    String? message,
    int? statusCode,
    List<GetPemesanan>? data,
  }) => GetAllPemesananModel(
    message: message ?? this.message,
    statusCode: statusCode ?? this.statusCode,
    data: data ?? this.data,
  );

  factory GetAllPemesananModel.fromRawJson(String str) =>
      GetAllPemesananModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetAllPemesananModel.fromJson(Map<String, dynamic> json) =>
      GetAllPemesananModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: List<GetPemesanan>.from(
          json["data"].map((x) => GetPemesanan.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetPemesanan {
  final int id;
  final String namaPenyewa;
  final String noHp;
  final String? deskripsi;
  final String alamatJemput;
  final String alamatAntar;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String? jamJemput;
  final String tipeMobil;
  final String? fotoFormulir;
  final String statusPemesanan;
  final String? totalHarga;
  final int? durasiHari;
  final SopirData sopir;
  final DateTime createdAt;
  final DateTime updatedAt;

  GetPemesanan({
    required this.id,
    required this.namaPenyewa,
    required this.noHp,
    this.deskripsi,
    required this.alamatJemput,
    required this.alamatAntar,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    this.jamJemput,
    required this.tipeMobil,
    this.fotoFormulir,
    required this.statusPemesanan,
    this.totalHarga,
    this.durasiHari,
    required this.sopir,
    required this.createdAt,
    required this.updatedAt,
  });

  GetPemesanan copyWith({
    int? id,
    String? namaPenyewa,
    String? noHp,
    String? deskripsi,
    String? alamatJemput,
    String? alamatAntar,
    String? tanggalMulai,
    String? tanggalSelesai,
    String? jamJemput,
    String? tipeMobil,
    String? fotoFormulir,
    String? statusPemesanan,
    String? totalHarga,
    int? durasiHari,
    SopirData? sopir,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GetPemesanan(
    id: id ?? this.id,
    namaPenyewa: namaPenyewa ?? this.namaPenyewa,
    noHp: noHp ?? this.noHp,
    deskripsi: deskripsi ?? this.deskripsi,
    alamatJemput: alamatJemput ?? this.alamatJemput,
    alamatAntar: alamatAntar ?? this.alamatAntar,
    tanggalMulai: tanggalMulai ?? this.tanggalMulai,
    tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
    jamJemput: jamJemput ?? this.jamJemput,
    tipeMobil: tipeMobil ?? this.tipeMobil,
    fotoFormulir: fotoFormulir ?? this.fotoFormulir,
    statusPemesanan: statusPemesanan ?? this.statusPemesanan,
    totalHarga: totalHarga ?? this.totalHarga,
    durasiHari: durasiHari ?? this.durasiHari,
    sopir: sopir ?? this.sopir,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory GetPemesanan.fromRawJson(String str) =>
      GetPemesanan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetPemesanan.fromJson(Map<String, dynamic> json) => GetPemesanan(
    id: json["id"],
    namaPenyewa: json["nama_penyewa"],
    noHp: json["no_hp"],
    deskripsi: json["deskripsi"],
    alamatJemput: json["alamat_jemput"],
    alamatAntar: json["alamat_antar"],
    tanggalMulai: json["tanggal_mulai"],
    tanggalSelesai: json["tanggal_selesai"],
    jamJemput: json["jam_jemput"],
    tipeMobil: json["tipe_mobil"],
    fotoFormulir: json["foto_formulir"],
    statusPemesanan: json["status_pemesanan"],
    totalHarga: json["total_harga"],
    durasiHari: json["durasi_hari"],
    sopir: SopirData.fromJson(json["sopir"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_penyewa": namaPenyewa,
    "no_hp": noHp,
    "deskripsi": deskripsi,
    "alamat_jemput": alamatJemput,
    "alamat_antar": alamatAntar,
    "tanggal_mulai": tanggalMulai,
    "tanggal_selesai": tanggalSelesai,
    "jam_jemput": jamJemput,
    "tipe_mobil": tipeMobil,
    "foto_formulir": fotoFormulir,
    "status_pemesanan": statusPemesanan,
    "total_harga": totalHarga,
    "durasi_hari": durasiHari,
    "sopir": sopir.toJson(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };

  // Helper methods
  String get statusColor {
    switch (statusPemesanan) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'confirmed':
        return '#008000'; // Green
      case 'completed':
        return '#0000FF'; // Blue
      case 'cancelled':
        return '#FF0000'; // Red
      default:
        return '#808080'; // Gray
    }
  }

  String get statusText {
    switch (statusPemesanan) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return statusPemesanan;
    }
  }

  String get formattedTotalHarga {
    if (totalHarga == null || totalHarga!.isEmpty) return '-';
    final harga = int.tryParse(totalHarga!) ?? 0;
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}

class SopirData {
  final int id;
  final String namaSopir;
  final String tipeMobil;
  final String noHp;
  final String? fotoSopir;
  final String? hargaPerHari;

  SopirData({
    required this.id,
    required this.namaSopir,
    required this.tipeMobil,
    required this.noHp,
    this.fotoSopir,
    this.hargaPerHari,
  });

  SopirData copyWith({
    int? id,
    String? namaSopir,
    String? tipeMobil,
    String? noHp,
    String? fotoSopir,
    String? hargaPerHari,
  }) => SopirData(
    id: id ?? this.id,
    namaSopir: namaSopir ?? this.namaSopir,
    tipeMobil: tipeMobil ?? this.tipeMobil,
    noHp: noHp ?? this.noHp,
    fotoSopir: fotoSopir ?? this.fotoSopir,
    hargaPerHari: hargaPerHari ?? this.hargaPerHari,
  );

  factory SopirData.fromRawJson(String str) => SopirData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SopirData.fromJson(Map<String, dynamic> json) => SopirData(
    id: json["id"],
    namaSopir: json["nama_sopir"],
    tipeMobil: json["tipe_mobil"],
    noHp: json["no_hp"],
    fotoSopir: json["foto_sopir"],
    hargaPerHari: json["harga_per_hari"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_sopir": namaSopir,
    "tipe_mobil": tipeMobil,
    "no_hp": noHp,
    "foto_sopir": fotoSopir,
    "harga_per_hari": hargaPerHari,
  };
}