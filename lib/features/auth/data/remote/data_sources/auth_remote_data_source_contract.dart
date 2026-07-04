import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/features/auth/data/models/response/login_response_dto.dart';
import 'package:flowery_rider/features/auth/data/models/response/logout_response_dto.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<LoginResponseDto>> login({
    required LoginRequest body,
    required bool isRememberMe,
  });
  Future<BaseResponse<LogOutResponseDto>> logout();
}
