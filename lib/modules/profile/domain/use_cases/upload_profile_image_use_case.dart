import 'dart:io';

import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../repositories/profile_repo_contract.dart';

@injectable
class UploadProfileImageUseCase {
  final ProfileRepoContract _repository;

  UploadProfileImageUseCase(this._repository);

  Future<BaseResponse<String>> execute(File imageFile) async {
    return await _repository.uploadProfileImage(imageFile);
  }
}
