import 'package:flowery_rider/config/base_state/base_state.dart';

class EditProfileState extends BaseState<String> {
  final bool isSuccess;

  const EditProfileState({
    super.isLoading = false,
    super.data,
    super.errorMessage,
    this.isSuccess = false,
  });

  EditProfileState copyWith({
    bool? isLoading,
    String? data,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [super.props, isSuccess];
}
