import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/models/request/apply_request_model.dart';
import '../../../../domain/use_cases/apply_use_case.dart';
import '../intent/apply_intent.dart';
import '../state/apply_state.dart';

@injectable
class ApplyCubit extends BaseCubit<ApplyState, BaseEvent> {
  final ApplyUseCase _applyUseCase;
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  ApplyCubit(this._applyUseCase) : super(const ApplyState()) {
    loadCountries();
  }

  Future<void> loadCountries() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/json/country.json',
      );
      final List<dynamic> data = json.decode(response);

      String? defaultCountry;
      final hasEgypt = data.any((c) => c['isoCode'] == 'EG');
      if (hasEgypt) {
        defaultCountry = 'EG';
      } else if (data.isNotEmpty) {
        defaultCountry = data.first['isoCode'];
      }

      emit(state.copyWith(countries: data, selectedCountry: defaultCountry));
    } catch (e) {
      emitEvent(DisplayError("Error loading countries: $e"));
    }
  }

  void handleIntent(ApplyIntent intent) {
    if (intent is SubmitApplyIntent) {
      _executeApply();
    } else if (intent is ChangeCountryIntent) {
      emit(state.copyWith(selectedCountry: intent.country));
    } else if (intent is ChangeVehicleTypeIntent) {
      emit(state.copyWith(selectedVehicleType: intent.type));
    } else if (intent is ChangeGenderIntent) {
      emit(state.copyWith(selectedGender: intent.gender));
    } else if (intent is PickImageIntent) {
      _pickImage(intent.isLicense);
    }
  }

  Future<void> _pickImage(bool isLicense) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isLicense) {
        emit(state.copyWith(vehicleLicenseFile: File(pickedFile.path)));
      } else {
        emit(state.copyWith(idImageFile: File(pickedFile.path)));
      }
    }
  }

  Future<void> _executeApply() async {
    if (state.vehicleLicenseFile == null || state.idImageFile == null) {
      emitEvent(const DisplayError("Please upload photos first"));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final selectedCountryName = state.countries
          .cast<Map<String, dynamic>?>()
          .firstWhere(
            (country) => country?['isoCode'] == state.selectedCountry,
            orElse: () => null,
          )?['name']
          ?.toString();

      final request = ApplyRequestModel(
        country: selectedCountryName ?? 'Egypt',
        firstName: firstNameController.text.trim(),
        lastName: secondNameController.text.trim(),
        vehicleType: state.selectedVehicleType,
        vehicleNumber: vehicleNumberController.text.trim(),
        vehicleLicense: state.vehicleLicenseFile!,
        nid: idNumberController.text.trim(),
        nidImg: state.idImageFile!,
        email: emailController.text.trim(),
        password: passwordController.text,
        rePassword: confirmPasswordController.text,
        gender: state.selectedGender.toLowerCase(),
        phone: _formatEgyptPhone(phoneController.text),
      );

      log(
        "🚀 Sending Country: ${request.country}, Phone: ${request.phone}, Vehicle: ${request.vehicleType}",
      );

      final response = await _applyUseCase(request);

      if (response is SuccessBaseResponse) {
        final resultEntity = (response as SuccessBaseResponse).data;
        emit(state.copyWith(isLoading: false, data: resultEntity));
        emitEvent(DisplaySuccess(resultEntity.message));
        emitEvent(const NavigateEvent(AppRouterPaths.kApplySuccessView));
      } else if (response is ErrorBaseResponse) {
        final errorMsg = (response as ErrorBaseResponse).errorMessage;
        log("❌ API Error Response: $errorMsg");
        emit(state.copyWith(isLoading: false, errorMessage: errorMsg));
        emitEvent(DisplayError(errorMsg));
      }
    } catch (e) {
      if (e is DioException) {
        log("🚨 Dio Error Response Data: ${e.response?.data}");
        log("🚨 Dio Error Status Code: ${e.response?.statusCode}");
      } else {
        log("💥 Crash: $e");
      }
      emit(state.copyWith(isLoading: false));
      emitEvent(const DisplayError("Something went wrong"));
    }
  }

  String _formatEgyptPhone(String phone) {
    final trimmedPhone = phone.trim();

    if (trimmedPhone.startsWith('+')) {
      return trimmedPhone;
    }

    if (trimmedPhone.startsWith('0')) {
      return '+20${trimmedPhone.substring(1)}';
    }

    return trimmedPhone;
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    secondNameController.dispose();
    vehicleNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
