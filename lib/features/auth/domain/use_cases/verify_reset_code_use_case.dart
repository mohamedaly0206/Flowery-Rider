import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../data/models/request/verify_reset_code_request.dart';
import '../entities/response/verify_reset_code_entity.dart';

@injectable
class VerifyResetCodeUseCase {
  final AuthRepoContract forgetPasswordRepoContract;

  VerifyResetCodeUseCase({required this.forgetPasswordRepoContract});

  Future<BaseResponse<VerifyResetCodeEntity>> call(
    VerifyResetCodeRequest request,
  ) {
    return forgetPasswordRepoContract.verifyResetCode(request);
  }
}
