import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/features/auth/domain/entities/login_response_entity.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final AuthRepoContract _authRepoContract;
  LoginUseCase(this._authRepoContract);

  Future<BaseResponse<LoginResponseEntity>> call({
    required LoginRequest body,
    required bool isRememberMe,
  }) => _authRepoContract.login(body: body, isRememberMe: isRememberMe);
}
