import 'dart:io';

import 'package:flowery_rider/modules/profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/modules/profile/data/models/response/profile_response_model.dart';

import '../../../../../../config/base_response/base_response.dart';
import '../../../models/change_password_request.dart';
import '../../../models/change_password_response_dto.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<ProfileResponseModel> getLoggedDriverData();
  Future<ProfileResponseModel> editProfile(EditProfileRequestModel request);
  Future<String> uploadProfileImage(File imageFile);
  Future<BaseResponse<ChangePasswordResponseDto>> changePassword(
    ChangePasswordRequest changePasswordRequestDto,
  );
}
