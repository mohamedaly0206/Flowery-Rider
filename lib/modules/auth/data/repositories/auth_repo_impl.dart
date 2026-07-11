import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/security_storage/security_storage.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/modules/auth/data/models/request/apply_request_model.dart';
import 'package:flowery_rider/modules/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/modules/auth/data/models/response/login_response_dto.dart';
import 'package:flowery_rider/modules/auth/data/models/response/logout_response_dto.dart';
import 'package:flowery_rider/modules/auth/domain/entities/apply_result_entity.dart';
import 'package:flowery_rider/modules/auth/data/remote/data_sources/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/modules/auth/domain/entities/login_response_entity.dart';
import 'package:flowery_rider/modules/auth/domain/entities/logout_response_entity.dart';
import 'package:flowery_rider/modules/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepoContract)
class AuthRepoImpl implements AuthRepoContract {
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;
  final SecurityStorage _securityStorage;
  AuthRepoImpl(this._authRemoteDataSourceContract, this._securityStorage);

  @override
  Future<BaseResponse<ApplyResultEntity>> applyAsDriver(
    ApplyRequestModel requestModel,
  ) async {
    try {
      final responseModel = await _authRemoteDataSourceContract.applyAsDriver(
        requestModel,
      );

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

  @override
  Future<BaseResponse<LoginResponseEntity>> login({
    required LoginRequest body,
    required bool isRememberMe,
  }) async {
    final response = await _authRemoteDataSourceContract.login(
      body: body,
      isRememberMe: isRememberMe,
    );
    switch (response) {
      case SuccessBaseResponse<LoginResponseDto>():
        if (isRememberMe) {
          await _securityStorage.setSecuredString(
            AppStrings.rememberMeToken,
            response.data.token ?? "",
          );
        }
        await _securityStorage.setSecuredString(
          AppStrings.token,
          response.data.token ?? "",
        );
        log('Token saved to secure storage: ${response.data.token}');

        return SuccessBaseResponse<LoginResponseEntity>(
          data: response.data.toDomain(),
        );

      case ErrorBaseResponse<LoginResponseDto>():
        return ErrorBaseResponse<LoginResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<LogoutResponseEntity>> logout() async {
    final response = await _authRemoteDataSourceContract.logout();
    switch (response) {
      case SuccessBaseResponse<LogOutResponseDto>():
        final token = await _securityStorage.getSecuredString(AppStrings.rememberMeToken);

        if (token.isNotEmpty) {
          await _securityStorage.deleteSecuredString(AppStrings.token);
          await _securityStorage.deleteSecuredString(
            AppStrings.rememberMeToken,
          );
          log('Token deleted from secure storage');
        }
        return SuccessBaseResponse<LogoutResponseEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<LogOutResponseDto>():
        return ErrorBaseResponse<LogoutResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}
