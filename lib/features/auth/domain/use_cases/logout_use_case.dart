import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/auth/domain/entities/logout_response_entity.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final AuthRepoContract _authRepoContract;

  LogoutUseCase(this._authRepoContract);

  Future<BaseResponse<LogoutResponseEntity>> call() async {
    return await _authRepoContract.logout();
  }
}
