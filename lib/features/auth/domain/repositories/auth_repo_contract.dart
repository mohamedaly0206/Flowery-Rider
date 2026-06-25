import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/auth/data/models/request/apply_request_model.dart';
import 'package:flowery_rider/features/auth/domain/entities/apply_result_entity.dart';

abstract interface class AuthRepoContract {
  Future<BaseResponse<ApplyResultEntity>> applyAsDriver(
    ApplyRequestModel requestModel,
  );
}
