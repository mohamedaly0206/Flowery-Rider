import 'package:flowery_rider/config/base_state/base_state.dart';
import '../../../../domain/entities/change_password_response_entity.dart';

class ChangePasswordState extends BaseState<ChangePasswordResponseEntity> {
  final bool isSuccess;

  const ChangePasswordState({
    super.isLoading = false,
    super.data,
    super.errorMessage,
    this.isSuccess = false,
  });

  ChangePasswordState copyWith({
    bool? isLoading,
    ChangePasswordResponseEntity? data,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [super.props, isSuccess];
}
