import 'package:flowery_rider/features/auth/data/data_sources/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../domain/entities/response/enter_reset_email_entity.dart';
import '../../domain/entities/response/reset_password_entity.dart';
import '../../domain/entities/response/verify_reset_code_entity.dart';
import '../models/request/enter_reset_email_request.dart';
import '../models/request/reset_password_request.dart';
import '../models/request/verify_reset_code_request.dart';
import '../models/response/enter_reset_email_dto.dart';
import '../models/response/reset_password_dto.dart';
import '../models/response/verify_reset_code_dto.dart';

@Injectable(as: AuthRepoContract)
class AuthRepoImpl implements AuthRepoContract {
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;

  AuthRepoImpl(this._authRemoteDataSourceContract);
  @override
  Future<BaseResponse<EnterResetEmailEntity>> enterResetEmail(
      EnterResetEmailRequest request,
      ) async {
    final response = await _authRemoteDataSourceContract
        .enterResetEmail(request);
    switch (response) {
      case SuccessBaseResponse<EnterResetEmailDTO>():
        return SuccessBaseResponse<EnterResetEmailEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<EnterResetEmailDTO>():
        return ErrorBaseResponse<EnterResetEmailEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<ResetPasswordEntity>> resetPassword(
      ResetPasswordRequest request,
      ) async {
    final response = await _authRemoteDataSourceContract.resetPassword(
      request,
    );
    switch (response) {
      case SuccessBaseResponse<ResetPasswordDTO>():
        return SuccessBaseResponse<ResetPasswordEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<ResetPasswordDTO>():
        return ErrorBaseResponse<ResetPasswordEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<VerifyResetCodeEntity>> verifyResetCode(
      VerifyResetCodeRequest request,
      ) async {
    final response = await _authRemoteDataSourceContract
        .verifyResetCode(request);
    switch (response) {
      case SuccessBaseResponse<VerifyResetCodeDTO>():
        return SuccessBaseResponse<VerifyResetCodeEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<VerifyResetCodeDTO>():
        return ErrorBaseResponse<VerifyResetCodeEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}
