import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base_cubit/base_cubit.dart';
import '../../../../../config/base_event/base_event.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../data/models/request/enter_reset_email_request.dart';
import '../../../data/models/request/reset_password_request.dart';
import '../../../data/models/request/verify_reset_code_request.dart';
import '../../../domain/entities/response/enter_reset_email_entity.dart';
import '../../../domain/entities/response/reset_password_entity.dart';
import '../../../domain/entities/response/verify_reset_code_entity.dart';
import '../../../domain/use_cases/enter_reset_email_use_case.dart';
import '../../../domain/use_cases/reset_password_use_case.dart';
import '../../../domain/use_cases/verify_reset_code_use_case.dart';
import '../intent/forget_password_intent.dart';

part '../state/forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends BaseCubit<ForgetPasswordState, BaseEvent> {
  ForgetPasswordCubit(
      this._enterResetEmailUseCase,
      this._resetPasswordUseCase,
      this._verifyResetCodeUseCase,
      ) : super(ForgetPasswordState());

  final EnterResetEmailUseCase _enterResetEmailUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final VerifyResetCodeUseCase _verifyResetCodeUseCase;

  void doIntent(ForgetPasswordIntent intent) {
    switch (intent) {
      case EnterResetEmailIntent():
        _enterEmail(intent.request);
        break;
      case VerifyResetCodeIntent():
        _verifyResetCode(intent.request);
        break;
      case ResetPasswordIntent():
        _resetPassword(intent.request);
        break;
    }
  }

  Future<void> _enterEmail(EnterResetEmailRequest request) async {
    emit(
      state.copyWith(
        enterEmailState: const BaseState(isLoading: true),
      ),
    );
    final response = await _enterResetEmailUseCase.call(request);
    switch (response) {
      case SuccessBaseResponse<EnterResetEmailEntity>():
        emit(
          state.copyWith(
            enterEmailState: BaseState(
              isLoading: false,
              data: response.data,
            ),
          ),
        );
        emit(state.copyWith(email: request.email));

        emitEvent(const DisplaySuccess('send reset code successfully'));
        break;

      case ErrorBaseResponse<EnterResetEmailEntity>():
        emit(
          state.copyWith(
            enterEmailState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );

        emitEvent(DisplayError(response.errorMessage));
        break;
    }
  }

  Future<void> _verifyResetCode(VerifyResetCodeRequest request) async {
    emit(
      state.copyWith(
        verifyResetCodeState: const BaseState(isLoading: true),
      ),
    );
    final response = await _verifyResetCodeUseCase.call(request);
    switch (response) {
      case SuccessBaseResponse<VerifyResetCodeEntity>():
        emit(
          state.copyWith(
            verifyResetCodeState: BaseState(
              isLoading: false,
              data: response.data,
            ),
          ),
        );

        emitEvent(const DisplaySuccess('تم التأكد من الكود بنجاح'));
        break;

      case ErrorBaseResponse<VerifyResetCodeEntity>():
        emit(
          state.copyWith(
            verifyResetCodeState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );

        emitEvent(DisplayError(response.errorMessage));
        break;
    }
  }

  Future<void> _resetPassword(ResetPasswordRequest request) async {
    emit(
      state.copyWith(
        resetPasswordState: const BaseState(isLoading: true),
      ),
    );
    final response = await _resetPasswordUseCase.call(request);
    switch (response) {
      case SuccessBaseResponse<ResetPasswordEntity>():
        emit(
          state.copyWith(
            resetPasswordState: BaseState(
              isLoading: false,
              data: response.data,
            ),
          ),
        );

        emitEvent(const DisplaySuccess('password reset successfully'));
        emitEvent(const NavigateEvent('/login'));
        break;

      case ErrorBaseResponse<ResetPasswordEntity>():
        emit(
          state.copyWith(
            resetPasswordState: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );

        emitEvent(DisplayError(response.errorMessage));
        break;
    }
  }
}