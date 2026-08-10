import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/models/change_password_request.dart';
import '../../../../domain/use_cases/change_password_use_case.dart';
import '../intent/change_password_intent.dart';
import '../state/change_password_state.dart';

@injectable
class ChangePasswordCubit extends BaseCubit<ChangePasswordState, BaseEvent> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit(this._changePasswordUseCase)
    : super(const ChangePasswordState());

  void handleIntent(ChangePasswordIntent intent) {
    if (intent is ExecuteChangePasswordIntent) {
      _changePassword(intent);
    }
  }

  Future<void> _changePassword(ExecuteChangePasswordIntent intent) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    final request = ChangePasswordRequest(
      password: intent.oldPassword,
      newPassword: intent.newPassword,
    );

    final response = await _changePasswordUseCase(request);

    if (response is SuccessBaseResponse) {
      final successResponse = response as SuccessBaseResponse;
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          data: successResponse.data,
        ),
      );
      emitEvent(
        DisplaySuccess(
          successResponse.data?.message ?? 'Password Changed Successfully!',
        ),
      );
    } else if (response is ErrorBaseResponse) {
      final errorMessage = (response as ErrorBaseResponse).errorMessage;
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
          isSuccess: false,
        ),
      );
      emitEvent(DisplayError(errorMessage));
    }
  }
}
