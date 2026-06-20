import 'package:flowery_rider/features/auth/api/api_client/auth_api_client.dart';
import 'package:flowery_rider/features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/request/enter_reset_email_request.dart';
import '../../data/models/request/reset_password_request.dart';
import '../../data/models/request/verify_reset_code_request.dart';
import '../../data/models/response/enter_reset_email_dto.dart';
import '../../data/models/response/reset_password_dto.dart';
import '../../data/models/response/verify_reset_code_dto.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);
  @override
  Future<BaseResponse<EnterResetEmailDTO>> enterResetEmail(
      EnterResetEmailRequest request,
      ) async {
    try {
      final response = await _authApiClient.enterResetEmail(request);
      return SuccessBaseResponse<EnterResetEmailDTO>(data: response);
    } catch (e) {
      return ErrorBaseResponse<EnterResetEmailDTO>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<VerifyResetCodeDTO>> verifyResetCode(
      VerifyResetCodeRequest request,
      ) async {
    try {
      final response = await _authApiClient.verifyResetCode(request);
      return SuccessBaseResponse<VerifyResetCodeDTO>(data: response);
    } catch (e) {
      return ErrorBaseResponse<VerifyResetCodeDTO>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<ResetPasswordDTO>> resetPassword(
      ResetPasswordRequest request,
      ) async {
    try {
      final response = await _authApiClient.resetPassword(request);
      return SuccessBaseResponse<ResetPasswordDTO>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ResetPasswordDTO>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }
}
