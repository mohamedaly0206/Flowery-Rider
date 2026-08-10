import 'package:dio/dio.dart';
import 'package:flowery_rider/core/values/api_endpoints.dart';
import 'package:flowery_rider/modules/profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/modules/profile/data/models/response/profile_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../models/change_password_request.dart';
import '../../../models/change_password_response_dto.dart';

part 'profile_api_client.g.dart';

@injectable
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(ApiEndpoints.getLoggedDriverData)
  Future<ProfileResponseModel> getLoggedDriverData();
  @PUT(ApiEndpoints.editProfile)
  Future<ProfileResponseModel> editProfile(
    @Body() EditProfileRequestModel request,
  );
  @PATCH(ApiEndpoints.changePassword)
  Future<ChangePasswordResponseDto> changePassword({
    @Body() required ChangePasswordRequest changePasswordRequestDto,
  });
}
