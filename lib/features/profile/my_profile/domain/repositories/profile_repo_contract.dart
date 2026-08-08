import 'dart:io';

import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/profile/my_profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/entities/driver_profile_entity.dart';

abstract interface class ProfileRepoContract {
  Future<BaseResponse<DriverProfileEntity>> getLoggedDriverData();
  Future<BaseResponse<DriverProfileEntity>> editProfile(
    EditProfileRequestModel request,
  );
  Future<BaseResponse<DriverProfileEntity>> uploadPhoto(File photo);
}
