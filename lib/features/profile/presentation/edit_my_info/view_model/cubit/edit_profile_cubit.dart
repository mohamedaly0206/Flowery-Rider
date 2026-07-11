import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/profile/data/models/edit_profile_request_model.dart';
import 'package:flowery_rider/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:flowery_rider/features/profile/presentation/edit_my_info/view_model/intent/edit_profile_intent.dart';
import 'package:flowery_rider/features/profile/presentation/edit_my_info/view_model/state/edit_profile_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileCubit extends BaseCubit<EditProfileState, BaseEvent> {
  final EditProfileUseCase _editProfileUseCase;

  EditProfileCubit(this._editProfileUseCase) : super(const EditProfileState());

  void handleIntent(EditProfileIntent intent) {
    if (intent is UpdateProfileFieldsIntent) {
      _updateProfileData(intent);
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
}
