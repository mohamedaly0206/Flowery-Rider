import 'dart:developer';

import 'package:flowery_rider/features/auth/data/data_sources/remote/api_client/auth_api_client.dart';
import 'package:flowery_rider/features/auth/data/data_sources/remote/auth_remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/data/models/request/apply_request_model.dart';
import 'package:flowery_rider/features/auth/data/models/response/apply_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<ApplyResponseModel> applyAsDriver(
    ApplyRequestModel requestModel,
  ) async {
    final formData = await requestModel.toFormData();
    log(
      "Apply FormData fields: ${formData.fields.map((field) => '${field.key}: ${field.value}').join(', ')}",
    );
    return await _authApiClient.applyAsDriver(formData);
  }
}
