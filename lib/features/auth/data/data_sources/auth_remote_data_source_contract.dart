import '../../../../config/base_response/base_response.dart';
import '../models/request/enter_reset_email_request.dart';
import '../models/request/reset_password_request.dart';
import '../models/request/verify_reset_code_request.dart';
import '../models/response/enter_reset_email_dto.dart';
import '../models/response/reset_password_dto.dart';
import '../models/response/verify_reset_code_dto.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<BaseResponse<EnterResetEmailDTO>> enterResetEmail(
      EnterResetEmailRequest request,
      );
  Future<BaseResponse<VerifyResetCodeDTO>> verifyResetCode(
      VerifyResetCodeRequest request,
      );
  Future<BaseResponse<ResetPasswordDTO>> resetPassword(
      ResetPasswordRequest request,
      );
}
