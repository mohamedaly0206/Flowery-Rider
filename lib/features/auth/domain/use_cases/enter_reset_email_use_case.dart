import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../data/models/request/enter_reset_email_request.dart';
import '../entities/response/enter_reset_email_entity.dart';

@injectable
class EnterResetEmailUseCase {
  final AuthRepoContract authRepoContract;

  EnterResetEmailUseCase({required this.authRepoContract});

  Future<BaseResponse<EnterResetEmailEntity>> call(
    EnterResetEmailRequest request,
  ) {
    return authRepoContract.enterResetEmail(request);
  }
}
