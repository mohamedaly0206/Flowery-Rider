import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/entities/driver_profile_entity.dart';

class ProfileState extends BaseState<DriverProfileEntity> {
  final String languageCode;

  const ProfileState({
    super.isLoading = false,
    super.data,
    super.errorMessage,
    this.languageCode = 'en',
  });

  ProfileState copyWith({
    bool? isLoading,
    DriverProfileEntity? data,
    String? errorMessage,
    String? languageCode,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [super.props, languageCode];
}
