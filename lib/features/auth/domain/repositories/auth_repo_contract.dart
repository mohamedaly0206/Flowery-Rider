import '../../../../config/base_response/base_response.dart';
import '../../data/models/request/enter_reset_email_request.dart';
import '../../data/models/request/reset_password_request.dart';
import '../../data/models/request/verify_reset_code_request.dart';
import '../entities/response/enter_reset_email_entity.dart';
import '../entities/response/reset_password_entity.dart';
import '../entities/response/verify_reset_code_entity.dart';

abstract interface class AuthRepoContract {
  Future<BaseResponse<EnterResetEmailEntity>> enterResetEmail(
      EnterResetEmailRequest request,
      );
  Future<BaseResponse<VerifyResetCodeEntity>> verifyResetCode(
      VerifyResetCodeRequest request,
      );
  Future<BaseResponse<ResetPasswordEntity>> resetPassword(
      ResetPasswordRequest request,
      );
}
