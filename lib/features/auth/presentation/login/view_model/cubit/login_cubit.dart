import 'dart:developer';

import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/features/auth/data/models/request/login_request.dart';
import 'package:flowery_rider/features/auth/domain/entities/login_response_entity.dart';
import 'package:flowery_rider/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flowery_rider/features/auth/presentation/login/view_model/intent/login_intent.dart';
import 'package:flowery_rider/features/auth/presentation/login/view_model/state/login_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, BaseEvent> {
  final LoginUseCase _loginUseCase;
  LoginCubit(LoginUseCase loginUseCase)
    : _loginUseCase = loginUseCase,
      super(const LoginState());

  void handleLoginIntent(LoginIntent intent) {
    switch (intent) {
      case TogglePasswordVisibilityIntent():
        _togglePasswordVisibility();
      case ToggleRememberMeIntent():
        _toggleRememberMe(intent.value ?? false);
      case SubmitLoginIntent():
        _login(email: intent.email, password: intent.password);
    }
  }

  void _togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
    log('obscurePassword: ${state.obscurePassword}');
  }

  void _toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
    log('rememberMe: ${state.rememberMe}');
  }

  Future<void> _login({required String email, required String password}) async {
    emit(state.copyWith(loginState: BaseState(isLoading: true)));
    final response = await _loginUseCase.call(
      body: LoginRequest(email: email, password: password),
      isRememberMe: state.rememberMe,
    );
    switch (response) {
      case SuccessBaseResponse<LoginResponseEntity>():
        emit(state.copyWith(loginState: BaseState(data: response.data)));
        emitEvent(DisplaySuccess('Login successful'));
        emitEvent(NavigateEvent(routeName: AppRouterPaths.kAppSections));
        break;
      case ErrorBaseResponse<LoginResponseEntity>():
        emit(
          state.copyWith(
            loginState: BaseState(errorMessage: response.errorMessage),
          ),
        );
        emitEvent(DisplayError(response.errorMessage));
        break;
    }
  }
}
