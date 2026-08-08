import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class VehicleDetailsView extends StatelessWidget {
  final DriverProfileEntity driver;

  const VehicleDetailsView({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: localizations.editProfile),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // 1️⃣ Vehicle Type
          TextFormField(
            initialValue: driver.displayVehicleType,
            readOnly: true,
            decoration: InputDecoration(
              labelText: localizations.vehicleType,
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.greyColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2️⃣ Vehicle Number
          TextFormField(
            initialValue: driver.vehicleNumber,
            readOnly: true,
            decoration: InputDecoration(labelText: 'Vehicle number'),
          ),
          const SizedBox(height: 16),

          // 3️⃣ Vehicle License
          TextFormField(
            initialValue: driver.vehicleLicense,
            readOnly: true,
            decoration: InputDecoration(
              labelText: localizations.vehicleLicense,
              suffixIcon: Icon(
                Icons.upload_outlined,
                color: AppColors.greyColor,
              ),
            ),
          ),
          const SizedBox(height: 180),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.placeHolderColor,
                disabledBackgroundColor: AppColors.placeHolderColor,
              ),
              onPressed: null,
              child: Text(
                localizations.update,
                style: const TextStyle(color: AppColors.whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
