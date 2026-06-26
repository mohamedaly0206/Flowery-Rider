

import '../../../data/models/request/enter_reset_email_request.dart';
import '../../../data/models/request/reset_password_request.dart';
import '../../../data/models/request/verify_reset_code_request.dart';

sealed class ForgetPasswordIntent {}

class EnterResetEmailIntent extends ForgetPasswordIntent {
  final EnterResetEmailRequest request;
  EnterResetEmailIntent(this.request);
}

class VerifyResetCodeIntent extends ForgetPasswordIntent {
  final VerifyResetCodeRequest request;
  VerifyResetCodeIntent(this.request);
}

class ResetPasswordIntent extends ForgetPasswordIntent {
  final ResetPasswordRequest request;
  ResetPasswordIntent(this.request);
}
