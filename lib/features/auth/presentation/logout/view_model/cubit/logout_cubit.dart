import 'dart:async';

import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/features/auth/domain/entities/logout_response_entity.dart';
import 'package:flowery_rider/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:flowery_rider/features/auth/presentation/logout/view_model/intent/logout_intent.dart';
import 'package:flowery_rider/features/auth/presentation/logout/view_model/state/logout_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutCubit extends BaseCubit<LogoutState, BaseEvent> {
  LogoutCubit(LogoutUseCase logoutUseCase)
    : _logoutUseCase = logoutUseCase,
      super(const LogoutState());
  final LogoutUseCase _logoutUseCase;

  void handleLogoutIntent(LogoutIntent intent) {
    switch (intent) {
      case GetLogoutIntent():
        logout();
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(logoutState: const BaseState(isLoading: true)));
    final response = await _logoutUseCase.call();
    switch (response) {
      case SuccessBaseResponse<LogoutResponseEntity>():
        emit(state.copyWith(logoutState: BaseState(data: response.data)));
        emitEvent(NavigateEvent(AppRouterPaths.kLoginView));
        break;
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            logoutState: BaseState(errorMessage: response.errorMessage),
          ),
        );
        emitEvent(DisplayError(response.errorMessage));
        break;
    }
  }
}

// Make sure to add your specific imports for:
// BaseEvent, NavigateEvent, DisplayError, AppMessages, etc.
