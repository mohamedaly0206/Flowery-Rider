import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/utilities/app_validators.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/modules/auth/presentation/apply/widgets/custom_build_upload_box.dart';
import 'package:flowery_rider/modules/auth/presentation/apply/widgets/custom_gender_selection.dart';
import 'package:flowery_rider/modules/auth/presentation/apply/widgets/custom_passwords_row.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../view_model/cubit/apply_cubit.dart';
import '../view_model/intent/apply_intent.dart';
import '../view_model/state/apply_state.dart';

const _vehicleTypeOptions = <String, String>{
  '676b31a45d05310ca82657ac': 'Car',
  '676b31a45d05310ca82657ab': 'Motorcycle',
};

class ApplyView extends StatefulWidget {
  const ApplyView({super.key});

  @override
  State<ApplyView> createState() => _ApplyViewState();
}

class _ApplyViewState extends State<ApplyView> {
  late final StreamSubscription<BaseEvent> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _eventSubscription = context.read<ApplyCubit>().eventStream.listen((event) {
      if (!mounted) return;

      if (event is DisplaySuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              event.message,
              style: TextStyle(color: AppColors.whiteColor),
            ),
            backgroundColor: AppColors.successColor,
          ),
        );
      } else if (event is DisplayError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              event.message,
              style: TextStyle(color: AppColors.whiteColor),
            ),
            backgroundColor: AppColors.errorColor,
          ),
        );
      } else if (event is NavigateEvent) {
        context.go(event.routeName);
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplyCubit>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.applyNow),
      body: BlocBuilder<ApplyCubit, ApplyState>(
        builder: (context, state) {
          return Stack(
            children: [
              Form(
                key: cubit.formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        style: AppTextStyles.textStyleMedium20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.youwanttobeadelivery,
                        style: AppTextStyles.textStyleMedium16.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                      const SizedBox(height: 28),

                      state.countries.isEmpty
                          ? Center(
                              child: SpinKitFadingCircle(
                                color: Theme.of(context).colorScheme.primary,
                                size: 50,
                              ),
                            )
                          : DropdownButtonFormField<String>(
                              initialValue:
                                  state.countries.any(
                                    (c) =>
                                        c['isoCode'] == state.selectedCountry,
                                  )
                                  ? state.selectedCountry
                                  : null,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.greyColor,
                                size: 24,
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(
                                  context,
                                )!.country,
                              ),
                              style: AppTextStyles.textStyleMedium14.copyWith(
                                color: AppColors.greyColor,
                              ),
                              dropdownColor: AppColors.whiteColor,
                              elevation: 2,
                              items: state.countries
                                  .map<DropdownMenuItem<String>>((country) {
                                    return DropdownMenuItem<String>(
                                      value: country['isoCode'],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(country['flag'] ?? ''),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              country['name'] ?? '',
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles
                                                  .textStyleRegular14
                                                  .copyWith(
                                                    color: AppColors.blackColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList(),
                              onChanged: (val) =>
                                  cubit.handleIntent(ChangeCountryIntent(val!)),
                            ),
                      const SizedBox(height: 16),

                      // First legal name
                      TextFormField(
                        controller: cubit.firstNameController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.firstLegalName,
                          hintText: AppLocalizations.of(
                            context,
                          )!.enterFirstLegalName,
                        ),
                        validator: (v) => AppValidators.validateName(
                          context,
                          v,
                          AppLocalizations.of(context)!.firstLegalName,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Second legal name
                      TextFormField(
                        controller: cubit.secondNameController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.secondLegalName,
                          hintText: AppLocalizations.of(
                            context,
                          )!.enterSecondLegalName,
                        ),
                        validator: (v) => AppValidators.validateName(
                          context,
                          v,
                          AppLocalizations.of(context)!.secondLegalName,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🚗 Vehicle Type Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: state.selectedVehicleType,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.greyColor,
                          size: 24,
                        ),
                        style: AppTextStyles.textStyleRegular14.copyWith(
                          color: AppColors.blackColor,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.vehicleType,
                        ),
                        dropdownColor: AppColors.whiteColor,
                        items: _vehicleTypeOptions.entries
                            .map(
                              (type) => DropdownMenuItem(
                                value: type.key,
                                child: Text(type.value),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            cubit.handleIntent(ChangeVehicleTypeIntent(val!)),
                      ),
                      const SizedBox(height: 16),

                      // Vehicle number
                      TextFormField(
                        controller: cubit.vehicleNumberController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.vehicleNumber,
                          hintText: AppLocalizations.of(
                            context,
                          )!.enterVehicleNumber,
                        ),
                        validator: (v) => AppValidators.validateVehicleNumber(
                          cubit.vehicleNumberController.text,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Vehicle license box
                      CustomBuildUploadBox(
                        file: state.vehicleLicenseFile,
                        label: AppLocalizations.of(context)!.vehicleLicense,
                        hint: AppLocalizations.of(context)!.uploadLicense,
                        onTap: () => cubit.handleIntent(
                          PickImageIntent(isLicense: true),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: cubit.emailController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.email,
                          hintText: AppLocalizations.of(context)!.enterEmail,
                        ),
                        validator: (v) => AppValidators.validateEmail(
                          context,
                          cubit.emailController.text,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Phone number
                      TextFormField(
                        controller: cubit.phoneController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.phone,
                          hintText: AppLocalizations.of(
                            context,
                          )!.enterPhoneNumber,
                        ),
                        validator: (v) => AppValidators.validatePhoneNumber(
                          context,
                          cubit.phoneController.text,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ID number
                      TextFormField(
                        controller: cubit.idNumberController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.idNumber,
                          hintText: AppLocalizations.of(context)!.enterIdNumber,
                        ),
                        validator: (v) => AppValidators.validateIDNumber(
                          cubit.idNumberController.text,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ID Image box
                      CustomBuildUploadBox(
                        file: state.idImageFile,
                        label: AppLocalizations.of(context)!.idImage,
                        hint: AppLocalizations.of(context)!.uploadIdImage,
                        onTap: () => cubit.handleIntent(
                          PickImageIntent(isLicense: false),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Passwords Row
                      CustomPasswordsRow(cubit: cubit),
                      const SizedBox(height: 24),

                      // Gender Selection
                      CustomGenderSelection(cubit: cubit, state: state),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.handleIntent(SubmitApplyIntent());
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.continueButton,
                            style: AppTextStyles.textStyleMedium16.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),

              if (state.isLoading)
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: Theme.of(context).colorScheme.primary,
                      size: 50,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
