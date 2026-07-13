import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/auth/data/models/request/apply_request_model.dart';
import 'package:flowery_rider/modules/auth/domain/entities/apply_result_entity.dart';
import 'package:flowery_rider/modules/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/modules/auth/domain/entities/login_response_entity.dart';
import 'package:flowery_rider/modules/auth/domain/entities/logout_response_entity.dart';

abstract interface class AuthRepoContract {
  Future<BaseResponse<ApplyResultEntity>> applyAsDriver(
    ApplyRequestModel requestModel,
  );

  Future<BaseResponse<LoginResponseEntity>> login({
    required LoginRequest body,
    required bool isRememberMe,
  });
  Future<BaseResponse<LogoutResponseEntity>> logout();
}
