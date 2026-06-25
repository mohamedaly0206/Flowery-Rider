import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/features/auth/presentation/apply/view_model/cubit/apply_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/apply/view_model/intent/apply_intent.dart';
import 'package:flowery_rider/features/auth/presentation/apply/view_model/state/apply_state.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomGenderSelection extends StatelessWidget {
  const CustomGenderSelection({
    super.key,
    required this.cubit,
    required this.state,
  });

  final ApplyCubit cubit;
  final ApplyState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.gender,
          style: AppTextStyles.textStyleMedium16.copyWith(
            color: AppColors.greyColor,
          ),
        ),
        const Spacer(),
        Radio<String>(
          value: 'Female',
          // ignore: deprecated_member_use
          groupValue: state.selectedGender,
          activeColor: const Color(0xFFD12B6B),
          onChanged: (val) => cubit.handleIntent(ChangeGenderIntent(val!)),
        ),
        Text(
          AppLocalizations.of(context)!.female,
          style: AppTextStyles.textStyleRegular14.copyWith(
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(width: 10),
        // ignore: deprecated_member_use
        Radio<String>(
          value: 'Male',
          groupValue: state.selectedGender,
          activeColor: AppColors.primaryColor,
          // ignore: deprecated_member_use
          onChanged: (val) => cubit.handleIntent(ChangeGenderIntent(val!)),
        ),
        Text(
          AppLocalizations.of(context)!.male,
          style: AppTextStyles.textStyleRegular14.copyWith(
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
