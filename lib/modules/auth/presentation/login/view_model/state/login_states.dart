import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/modules/auth/domain/entities/login_response_entity.dart';

class LoginState extends Equatable {
  final BaseState<LoginResponseEntity> loginState;
  final bool obscurePassword;
  final bool rememberMe;

  const LoginState({
    this.loginState = const BaseState(),
    this.obscurePassword = true,
    this.rememberMe = false,
  });
  LoginState copyWith({
    BaseState<LoginResponseEntity>? loginState,
    bool? obscurePassword,
    bool? rememberMe,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [loginState, obscurePassword, rememberMe];
}
