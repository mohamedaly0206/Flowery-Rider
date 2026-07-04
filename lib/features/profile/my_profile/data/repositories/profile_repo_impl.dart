import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/profile/my_profile/data/data_sources/remote/profile_remote_data_source/profile_remote_data_source_contract.dart';
import 'package:flowery_rider/features/profile/my_profile/data/models/edit_profile_request_model%20copy.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/repositories/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepoContract)
class ProfileRepoImpl implements ProfileRepoContract {
  final ProfileRemoteDataSourceContract _remoteDataSource;

  ProfileRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<DriverProfileEntity>> getLoggedDriverData() async {
    try {
      final response = await _remoteDataSource.getLoggedDriverData();
      final driver = response.driver;

      if (driver == null) {
        return ErrorBaseResponse(errorMessage: 'Profile data not found');
      }

      return SuccessBaseResponse(data: driver.toEntity());
    } on DioException catch (e) {
      return ErrorBaseResponse(errorMessage: _extractErrorMessage(e));
    } catch (e) {
      return ErrorBaseResponse(errorMessage: e.toString());
    }
  }

  String _extractErrorMessage(DioException exception) {
    final respData = exception.response?.data;

    if (respData is Map && respData['message'] != null) {
      return respData['message'].toString();
    }

    if (respData is Map && respData['error'] != null) {
      return respData['error'].toString();
    }

    if (respData is Map && respData['errors'] != null) {
      return respData['errors'].toString();
    }

    if (respData is String) {
      try {
        final parsed = json.decode(respData);
        if (parsed is Map && parsed['message'] != null) {
          return parsed['message'].toString();
        }
      } catch (_) {
        return respData;
      }
    }

    return exception.message ?? 'Something went wrong';
  }

  @override
  Future<BaseResponse<DriverProfileEntity>> editProfile(
    EditProfileRequestModel request,
  ) async {
    try {
      final response = await _remoteDataSource.editProfile(request);
      final driver = response.driver;

      if (driver == null) {
        return ErrorBaseResponse(errorMessage: 'Failed to update profile data');
      }

      return SuccessBaseResponse(data: driver.toEntity());
    } on DioException catch (e) {
      return ErrorBaseResponse(errorMessage: _extractErrorMessage(e));
    } catch (e) {
      return ErrorBaseResponse(errorMessage: e.toString());
    }
  }
}
