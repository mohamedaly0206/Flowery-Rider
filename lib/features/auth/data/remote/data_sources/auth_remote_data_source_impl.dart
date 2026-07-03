import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/errors/failures.dart';
import 'package:flowery_rider/features/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/features/auth/data/models/response/login_response_dto.dart';
import 'package:flowery_rider/features/auth/data/models/response/logout_response_dto.dart';
import 'package:flowery_rider/features/auth/data/remote/api_client/auth_api_client.dart';
import 'package:flowery_rider/features/auth/data/remote/data_sources/auth_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;
  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<BaseResponse<LoginResponseDto>> login({
    required LoginRequest body,
    required bool isRememberMe,
  }) async {
    try {
      final response = await _authApiClient.login(body: body);
      return SuccessBaseResponse<LoginResponseDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<LoginResponseDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<LogOutResponseDto>> logout() async {
    try {
      final response = await _authApiClient.logout();
      return SuccessBaseResponse<LogOutResponseDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<LogOutResponseDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }
}
