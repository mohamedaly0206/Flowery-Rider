import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../data/models/request/reset_password_request.dart';
import '../entities/response/reset_password_entity.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepoContract authRepoContract;

  ResetPasswordUseCase({required this.authRepoContract});

  Future<BaseResponse<ResetPasswordEntity>> call(ResetPasswordRequest request) {
    return authRepoContract.resetPassword(request);
  }
}
