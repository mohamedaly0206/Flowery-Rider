import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowery_rider/core/values/api_endpoints.dart';
import 'package:flowery_rider/features/profile/my_profile/data/models/edit_profile_request_model%20copy.dart';
import 'package:flowery_rider/features/profile/my_profile/data/models/response/profile_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

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
  @PUT(ApiEndpoints.uploadDriverProfilePhoto)
  @MultiPart()
  Future<dynamic> uploadProfileImage(
    @Part(name: "photo") MultipartFile image,
  );
}
