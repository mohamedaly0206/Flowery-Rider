import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/modules/profile/domain/entities/driver_profile_entity.dart';

import '../../data/models/change_password_request.dart';
import '../entities/change_password_response_entity.dart';

abstract interface class ProfileRepoContract {
  Future<BaseResponse<DriverProfileEntity>> getLoggedDriverData();
  Future<BaseResponse<DriverProfileEntity>> editProfile(
    EditProfileRequestModel request,
  );
  Future<BaseResponse<ChangePasswordResponseEntity>> changePassword(
      ChangePasswordRequest changePasswordRequest,
      );
}
