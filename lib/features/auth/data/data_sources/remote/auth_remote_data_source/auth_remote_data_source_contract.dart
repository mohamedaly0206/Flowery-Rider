import 'package:flowery_rider/features/auth/data/models/request/apply_request_model.dart';
import 'package:flowery_rider/features/auth/data/models/response/apply_response_model.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<ApplyResponseModel> applyAsDriver(ApplyRequestModel requestModel);
}
