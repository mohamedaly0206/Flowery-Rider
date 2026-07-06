import 'dart:developer';

import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/security_storage/security_storage.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/features/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/features/auth/data/models/response/login_response_dto.dart';
import 'package:flowery_rider/features/auth/data/models/response/logout_response_dto.dart';
import 'package:flowery_rider/features/auth/data/remote/data_sources/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/domain/entities/login_response_entity.dart';
import 'package:flowery_rider/features/auth/domain/entities/logout_response_entity.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepoContract)
class AuthRepoImpl implements AuthRepoContract {
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;
  final SecurityStorage _securityStorage;
  AuthRepoImpl(this._authRemoteDataSourceContract, this._securityStorage);
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
        final token = await _securityStorage.getSecuredString(AppStrings.token);

        if (token.isNotEmpty) {
          await _securityStorage.deleteSecuredString(AppStrings.token);
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
