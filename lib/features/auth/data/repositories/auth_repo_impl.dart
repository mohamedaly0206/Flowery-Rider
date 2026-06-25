import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/auth/data/data_sources/remote/auth_remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/data/models/request/apply_request_model.dart';
import 'package:flowery_rider/features/auth/domain/entities/apply_result_entity.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepoContract)
class AuthRepoImpl implements AuthRepoContract {
  final AuthRemoteDataSourceContract _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<ApplyResultEntity>> applyAsDriver(
    ApplyRequestModel requestModel,
  ) async {
    try {
      final responseModel = await _remoteDataSource.applyAsDriver(requestModel);

      final entity = ApplyResultEntity(
        message: responseModel.message ?? "Success",
      );
      return SuccessBaseResponse(data: entity);
    } on DioException catch (e) {
      final respData = e.response?.data;
      final statusCode = e.response?.statusCode;
      String errorMessage = "Something went wrong";

      log("Apply Dio status: $statusCode");
      log("Apply Dio data: $respData");
      log("Apply Dio message: ${e.message}");

      if (respData != null) {
        if (respData is Map && respData['message'] != null) {
          errorMessage = respData['message'].toString();
        } else if (respData is Map && respData['error'] != null) {
          errorMessage = respData['error'].toString();
        } else if (respData is Map && respData['errors'] != null) {
          errorMessage = respData['errors'].toString();
        } else if (respData is Map) {
          errorMessage = respData.toString();
        } else if (respData is String) {
          try {
            final parsed = json.decode(respData);
            if (parsed is Map && parsed['message'] != null) {
              errorMessage = parsed['message'].toString();
            } else if (parsed is Map && parsed['error'] != null) {
              errorMessage = parsed['error'].toString();
            } else if (parsed is Map && parsed['errors'] != null) {
              errorMessage = parsed['errors'].toString();
            } else {
              errorMessage = respData;
            }
          } catch (_) {
            errorMessage = respData;
          }
        }
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      return ErrorBaseResponse(errorMessage: errorMessage);
    } catch (e) {
      return ErrorBaseResponse(errorMessage: e.toString());
    }
  }
}
