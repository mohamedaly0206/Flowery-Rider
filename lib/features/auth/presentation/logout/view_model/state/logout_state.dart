import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';

class LogoutState extends Equatable {
  final BaseState logoutState;

  const LogoutState({this.logoutState = const BaseState()});
  LogoutState copyWith({BaseState? logoutState}) {
    return LogoutState(logoutState: logoutState ?? this.logoutState);
  }

  @override
  List<Object?> get props => [logoutState];
}
