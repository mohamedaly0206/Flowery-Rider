import 'dart:developer';
import 'dart:io';

import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/models/edit_profile_request_model.dart';
import '../../../../domain/use_cases/edit_profile_use_case.dart';
import '../../../../domain/use_cases/upload_profile_image_use_case.dart';
import '../intent/edit_profile_intent.dart';
import '../state/edit_profile_state.dart';

@injectable
class EditProfileCubit extends BaseCubit<EditProfileState, BaseEvent> {
  final EditProfileUseCase _editProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;

  EditProfileCubit(this._editProfileUseCase, this._uploadProfileImageUseCase)
    : super(const EditProfileState());

  void handleIntent(EditProfileIntent intent) {
    if (intent is UpdateProfileFieldsIntent) {
      _updateProfileData(intent);
    } else if (intent is UploadProfileImageIntent) {
      _uploadProfileImage(intent.imageFile);
    }
  }

  Future<void> _updateProfileData(UpdateProfileFieldsIntent intent) async {
    emit(state.copyWith(isLoading: true));

    final request = EditProfileRequestModel(
      firstName: intent.firstName,
      lastName: intent.lastName,
      email: intent.email,
      phone: intent.phone,
    );

    final response = await _editProfileUseCase(request);

    if (response is SuccessBaseResponse) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
      emitEvent(DisplaySuccess('Profile Updated Successfully!'));
    } else if (response is ErrorBaseResponse) {
      final errorMessage = (response as ErrorBaseResponse).errorMessage;
      emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
      emitEvent(DisplayError(errorMessage));
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    emit(state.copyWith(isLoading: true));

    final response = await _uploadProfileImageUseCase.execute(imageFile);

    if (response is SuccessBaseResponse) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
      emitEvent(DisplaySuccess('Profile Picture Updated Successfully! 🎉'));
    } else if (response is ErrorBaseResponse) {
      final errorMessage = (response as ErrorBaseResponse).errorMessage;
      emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
      log(errorMessage);
      emitEvent(DisplayError(errorMessage));
    }
  }
}
