import 'dart:io';

import 'package:flowery_rider/config/base_response/base_response.dart';

import '../../data/models/edit_profile_request_model.dart';
import '../entities/driver_profile_entity.dart';

abstract interface class ProfileRepoContract {
  Future<BaseResponse<DriverProfileEntity>> getLoggedDriverData();
  Future<BaseResponse<DriverProfileEntity>> editProfile(
    EditProfileRequestModel request,
  );
  Future<BaseResponse<String>> uploadProfileImage(File imageFile);
}
