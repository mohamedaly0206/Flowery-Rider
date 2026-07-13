import 'dart:io';
import 'package:flowery_rider/config/base_state/base_state.dart';
import '../../../../domain/entities/apply_result_entity.dart';

const String kDefaultVehicleTypeId = '676b31a45d05310ca82657ac';

class ApplyState extends BaseState<ApplyResultEntity> {
  final List<dynamic> countries;
  final String? selectedCountry;
  final String selectedVehicleType;
  final String selectedGender;
  final File? vehicleLicenseFile;
  final File? idImageFile;

  const ApplyState({
    super.isLoading = false,
    super.data,
    super.errorMessage,
    this.countries = const [],
    this.selectedCountry,
    this.selectedVehicleType = kDefaultVehicleTypeId,
    this.selectedGender = 'Male',
    this.vehicleLicenseFile,
    this.idImageFile,
  });

  ApplyState copyWith({
    bool? isLoading,
    ApplyResultEntity? data,
    String? errorMessage,
    List<dynamic>? countries,
    String? selectedCountry,
    String? selectedVehicleType,
    String? selectedGender,
    File? vehicleLicenseFile,
    File? idImageFile,
  }) {
    return ApplyState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      countries: countries ?? this.countries,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      selectedGender: selectedGender ?? this.selectedGender,
      vehicleLicenseFile: vehicleLicenseFile ?? this.vehicleLicenseFile,
      idImageFile: idImageFile ?? this.idImageFile,
    );
  }

  @override
  List<Object?> get props => [
    super.props,
    countries,
    selectedCountry,
    selectedVehicleType,
    selectedGender,
    vehicleLicenseFile,
    idImageFile,
  ];
}
