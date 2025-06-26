
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:siapantar/data/model/request/penyewa/penyewa_profile_request_model.dart';
import 'package:siapantar/data/model/response/penyewa/penyewa_profile_response_model.dart';
import 'package:siapantar/services/service_http_client.dart';

class ProfileBuyerRepository {
  final ServiceHttpClient _serviceHttpClient;
  ProfileBuyerRepository(this._serviceHttpClient);

  Future<Either<String, PenyewaProfileResponseModel>> addProfileBuyer(
    PenyewaProfileRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "buyer/profile",
        requestModel.toMap(),
      );

      log(response.statusCode.toString());

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        final profileResponse = PenyewaProfileResponseModel.fromJson(
          jsonResponse,
        );
        return Right(profileResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      return Left("An error occurred while adding profile: $e");
    }
  }

  Future<Either<String, PenyewaProfileResponseModel>> getProfileBuyer() async {
    try {
      final response = await _serviceHttpClient.get("buyer/profile");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final profileResponse = PenyewaProfileResponseModel.fromJson(
          jsonResponse,
        );
        print("Profile Response: $profileResponse");
        return Right(profileResponse);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      return Left("An error occurred while fetching profile: $e");
    }
  }
}