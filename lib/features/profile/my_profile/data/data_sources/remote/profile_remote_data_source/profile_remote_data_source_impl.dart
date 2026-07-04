import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowery_rider/features/profile/my_profile/data/data_sources/remote/api_client/profile_api_client.dart';
import 'package:flowery_rider/features/profile/my_profile/data/data_sources/remote/profile_remote_data_source/profile_remote_data_source_contract.dart';
import 'package:flowery_rider/features/profile/my_profile/data/models/edit_profile_request_model%20copy.dart';
import 'package:flowery_rider/features/profile/my_profile/data/models/response/profile_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient _profileApiClient;

  ProfileRemoteDataSourceImpl(this._profileApiClient);

  @override
  Future<ProfileResponseModel> getLoggedDriverData() {
    return _profileApiClient.getLoggedDriverData();
  }

  @override
  Future<ProfileResponseModel> editProfile(
    EditProfileRequestModel request,
  ) async {
    return _profileApiClient.editProfile(request);
  }
}
