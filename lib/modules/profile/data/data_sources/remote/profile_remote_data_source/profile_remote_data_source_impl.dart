import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowery_rider/modules/profile/data/data_sources/remote/api_client/profile_api_client.dart';
import 'package:flowery_rider/modules/profile/data/data_sources/remote/profile_remote_data_source/profile_remote_data_source_contract.dart';
import 'package:flowery_rider/modules/profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/modules/profile/data/models/response/profile_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../../config/base_response/base_response.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../models/change_password_request.dart';
import '../../../models/change_password_response_dto.dart';

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

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    final String fileName = imageFile.path.split('/').last;
    final String extension = fileName.split('.').last.toLowerCase();
    final String mimeType = (extension == 'png') ? 'png' : 'jpeg';

    final multipartFile = await MultipartFile.fromFile(
      imageFile.path,
      filename: fileName,
      contentType: MediaType('image', mimeType),
    );

    final response = await _profileApiClient.uploadProfileImage(multipartFile);

    return response['message'] ?? 'Success';
  }

  @override
  Future<BaseResponse<ChangePasswordResponseDto>> changePassword(
    ChangePasswordRequest changePasswordRequestDto,
  ) async {
    try {
      final response = await _profileApiClient.changePassword(
        changePasswordRequestDto: changePasswordRequestDto,
      );
      return SuccessBaseResponse<ChangePasswordResponseDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ChangePasswordResponseDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }
}
