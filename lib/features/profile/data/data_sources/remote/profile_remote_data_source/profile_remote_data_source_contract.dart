import 'package:flowery_rider/features/profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/features/profile/data/models/response/profile_response_model.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<ProfileResponseModel> getLoggedDriverData();
  Future<ProfileResponseModel> editProfile(EditProfileRequestModel request);
}
