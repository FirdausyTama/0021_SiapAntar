import 'dart:convert';


import 'package:dartz/dartz.dart';
import 'package:siapantar/data/model/request/admin/admin_sopir_request.dart';
import 'package:siapantar/data/model/response/get_all_sopir_response_model.dart';
import 'package:siapantar/services/service_http_client.dart';
import 'package:dartz/dartz.dart';

class SopirRepository {
  final ServiceHttpClient _serviceHttpClient;

  SopirRepository(this._serviceHttpClient);

  Future<Either<String, GetSopirById>> addSopir(
    SopirRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "admin/sopir",
        requestModel.toJson(),
      );

      if (response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final profileResponse = GetSopirById.fromJson(jsonResponse);
          return Right(profileResponse);
        } else {
          return Left('Response kosong dari server');
        }
      } else {
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal menambah sopir');
        } else {
          return Left('Gagal menambah sopir - response kosong');
        }
      }
    } catch (e) {
      return Left("An error occurred while adding sopir: $e");
    }
  }

  Future<Either<String, GetAllSopirModel>> getAllSopir() async {
    try {
      final response = await _serviceHttpClient.get("admin/sopir");

      if (response.statusCode == 200) {
        // Cek apakah response body kosong atau tidak
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final profileResponse = GetAllSopirModel.fromJson(jsonResponse);
          return Right(profileResponse);
        } else {
          return Left('Response kosong dari server');
        }
      } else {
        // Handle error response
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal mengambil data sopir');
        } else {
          return Left('Gagal mengambil data sopir - response kosong');
        }
      }
    } catch (e) {
      return Left("An error occurred while getting all sopir: $e");
    }
  }

  Future<Either<String, GetSopirById>> getSopirById(int id) async {
    try {
      final response = await _serviceHttpClient.get("admin/sopir/$id");

      if (response.statusCode == 200) {
        // Cek apakah response body kosong atau tidak
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final profileResponse = GetSopirById.fromJson(jsonResponse);
          return Right(profileResponse);
        } else {
          return Left('Response kosong dari server');
        }
      } else {
        // Handle error response
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Sopir tidak ditemukan');
        } else {
          return Left('Sopir tidak ditemukan - response kosong');
        }
      }
    } catch (e) {
      return Left("An error occurred while getting sopir: $e");
    }
  }

  Future<Either<String, GetSopirById>> updateSopir(
    int id,
    SopirRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.putWithToken(
        "admin/sopir/$id",
        requestModel.toJson(),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          final profileResponse = GetSopirById.fromJson(jsonResponse);
          return Right(profileResponse);
        } else {
          return Left('Response body kosong');
        }
      } else {
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal mengupdate sopir');
        } else {
          return Left('HTTP Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      return Left("An error occurred while updating sopir: $e");
    }
  }

  Future<Either<String, String>> deleteSopir(int id) async {
    try {
      final response = await _serviceHttpClient.deleteWithToken("admin/sopir/$id");

      if (response.statusCode == 200) {
        // Cek apakah response body kosong atau tidak
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          return Right(jsonResponse['message'] ?? 'Sopir berhasil dihapus');
        } else {
          return Right('Sopir berhasil dihapus');
        }
      } else {
        // Handle error response
        if (response.body.isNotEmpty) {
          final errorMessage = json.decode(response.body);
          return Left(errorMessage['message'] ?? 'Gagal menghapus sopir');
        } else {
          return Left('Gagal menghapus sopir');
        }
      }
    } catch (e) {
      return Left("An error occurred while deleting sopir: $e");
    }
  }
}