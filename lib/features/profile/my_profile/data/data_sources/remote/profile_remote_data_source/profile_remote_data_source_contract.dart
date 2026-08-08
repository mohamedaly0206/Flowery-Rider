import 'dart:io';

import 'package:flowery_rider/features/profile/my_profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/features/profile/my_profile/data/models/response/profile_response_model.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<ProfileResponseModel> getLoggedDriverData();
  Future<ProfileResponseModel> editProfile(EditProfileRequestModel request);
  Future<ProfileResponseModel> uploadPhoto(File photo);
}
