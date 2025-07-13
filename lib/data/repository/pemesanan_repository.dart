import 'dart:convert';

import 'package:siapantar/data/model/request/penyewa/pemesanan_request_model.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';
import 'package:siapantar/data/model/response/penyewa/get_all_pemesanan_response.dart';
import 'package:siapantar/services/service_http_client.dart';
import 'package:dartz/dartz.dart';

class PemesananRepository {
  final ServiceHttpClient _serviceHttpClient;

  PemesananRepository(this._serviceHttpClient);

  // Buat pemesanan baru (untuk buyer)
  Future<Either<String, GetPemesananById>> createPemesanan(
    PemesananRequestModel requestModel,
  ) async {
    try {
      // Debug: print data yang akan dikirim
      print('Sending data: ${requestModel.toJson()}');
      
      final response = await _serviceHttpClient.postWithToken(
        "pemesanan",
        requestModel.toJson(),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final pemesananResponse = GetPemesananById.fromJson(jsonResponse);
          return Right(pemesananResponse);
        } else {
          return Left('Response kosong dari server');
        }
      } else {
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal membuat pemesanan');
        } else {
          return Left('Gagal membuat pemesanan - response kosong');
        }
      }
    } catch (e) {
      print('Error creating pemesanan: $e');
      return Left("An error occurred while creating pemesanan: $e");
    }
  }

  // Ambil semua pemesanan (untuk admin)
  Future<Either<String, GetAllPemesananModel>> getAllPemesanan() async {
    try {
      final response = await _serviceHttpClient.get("admin/pemesanan");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final pemesananResponse = GetAllPemesananModel.fromJson(jsonResponse);
          return Right(pemesananResponse);
        } else {
          return Left('Response kosong dari server');
        }
      } else {
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal mengambil data pemesanan');
        } else {
          return Left('Gagal mengambil data pemesanan - response kosong');
        }
      }
    } catch (e) {
      return Left("An error occurred while getting all pemesanan: $e");
    }
  }

  // Update status pemesanan (untuk admin)
  Future<Either<String, String>> updateStatusPemesanan(
    int id,
    String status,
  ) async {
    try {
      final response = await _serviceHttpClient.putWithToken(
        "admin/pemesanan/$id/status",
        {"status_pemesanan": status},
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          return Right(jsonResponse['message'] ?? 'Status berhasil diperbarui');
        } else {
          return Right('Status berhasil diperbarui');
        }
      } else {
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal mengupdate status');
        } else {
          return Left('Gagal mengupdate status - response kosong');
        }
      }
    } catch (e) {
      return Left("An error occurred while updating status: $e");
    }
  }

  // Ambil detail pemesanan by ID
  Future<Either<String, GetPemesananById>> getPemesananById(int id) async {
    try {
      final response = await _serviceHttpClient.get("admin/pemesanan/$id");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final pemesananResponse = GetPemesananById.fromJson(jsonResponse);
          return Right(pemesananResponse);
        } else {
          return Left('Response kosong dari server');
        }
      } else {
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Pemesanan tidak ditemukan');
        } else {
          return Left('Pemesanan tidak ditemukan - response kosong');
        }
      }
    } catch (e) {
      return Left("An error occurred while getting pemesanan: $e");
    }
  }

  // Ambil daftar sopir tersedia (untuk form pemesanan)
  Future<Either<String, GetAllSopirModel>> getSopirTersedia({
    String? tanggalMulai,
    String? tanggalSelesai,
  }) async {
    try {
      String endpoint = "admin/sopir/";
      
      // Tambahkan query parameter jika ada
      if (tanggalMulai != null && tanggalSelesai != null) {
        endpoint += "?tanggal_mulai=$tanggalMulai&tanggal_selesai=$tanggalSelesai";
      }

      final response = await _serviceHttpClient.get(endpoint);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final sopirResponse = GetAllSopirModel.fromJson(jsonResponse);
          return Right(sopirResponse);
        } else {
          return Left('Response kosong dari server');
        }
      } else {
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal mengambil data sopir');
        } else {
          return Left('Gagal mengambil data sopir - response kosong');
        }
      }
    } catch (e) {
      return Left("An error occurred while getting sopir tersedia: $e");
    }
  }
}