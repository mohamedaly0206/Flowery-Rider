import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/profile/domain/repositories/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/change_password_request.dart';
import '../entities/change_password_response_entity.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepoContract _repository;

  ChangePasswordUseCase(this._repository);

  Future<BaseResponse<ChangePasswordResponseEntity>> call(
    ChangePasswordRequest changePasswordRequest,
  ) {
    return _repository.changePassword(changePasswordRequest);
  }
}
