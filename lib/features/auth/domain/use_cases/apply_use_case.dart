import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/request/apply_request_model.dart';
import '../entities/apply_result_entity.dart';
import '../repositories/auth_repo_contract.dart';

@injectable
class ApplyUseCase {
  final AuthRepoContract _authRepoContract;

  ApplyUseCase(this._authRepoContract);

  Future<BaseResponse<ApplyResultEntity>> call(
    ApplyRequestModel request,
  ) async {
    return await _authRepoContract.applyAsDriver(request);
  }
}
