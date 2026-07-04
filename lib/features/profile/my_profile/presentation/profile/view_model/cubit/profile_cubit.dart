import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/security_storage/security_storage.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/use_cases/get_logged_driver_data_use_case.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/view_model/intent/profile_intent.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/view_model/state/profile_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState, BaseEvent> {
  final GetLoggedDriverDataUseCase _getLoggedDriverDataUseCase;
  final SecurityStorage _secureStorage;
  ProfileCubit(this._getLoggedDriverDataUseCase, this._secureStorage)
    : super(const ProfileState()) {
    handleIntent(LoadProfileIntent());
  }

  void handleIntent(ProfileIntent intent) {
    if (intent is LoadProfileIntent) {
      _getLoggedDriverData();
    }
    //  else if (intent is ChangeLanguageIntent) {
    //   _changeLanguage(intent.languageCode);
    // }
  }

  Future<void> _getLoggedDriverData() async {
    emit(state.copyWith(isLoading: true));
    await _secureStorage.setSecuredString(
      'token',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkcml2ZXIiOiI2YTJmNjQzYjk5MjYxMmFlNTk5YTg3YzUiLCJpYXQiOjE3ODMwNDY4Mjd9.RCZPRgJMyZbmpZZv0K5inb01fyhS0SwoXp4ljWVTofA',
    );
    final response = await _getLoggedDriverDataUseCase();

    if (response is SuccessBaseResponse) {
      emit(
        state.copyWith(
          isLoading: false,
          data: (response as SuccessBaseResponse).data,
        ),
      );
    } else if (response is ErrorBaseResponse) {
      final errorMessage = (response as ErrorBaseResponse).errorMessage;
      emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
      emitEvent(DisplayError(errorMessage));
    }
  }

  // void _changeLanguage(String languageCode) {
  //   emit(state.copyWith(languageCode: languageCode));
  //   emitEvent(ChangeLocaleEvent(languageCode));
  // }
}
