import 'package:flowery_rider/core/utilities/app_validators.dart';
import 'package:flowery_rider/features/auth/presentation/apply/view_model/cubit/apply_cubit.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomPasswordsRow extends StatelessWidget {
  const CustomPasswordsRow({super.key, required this.cubit});

  final ApplyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: cubit.passwordController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.password,
              hintText: AppLocalizations.of(context)!.enterPassword,
            ),
            validator: (v) => AppValidators.validatePassword(
              context,
              cubit.passwordController.text,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: cubit.confirmPasswordController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.confirmPassword,
              hintText: AppLocalizations.of(context)!.confirmPassword,
            ),
            validator: (v) => AppValidators.validatePassword(
              context,
              cubit.confirmPasswordController.text,
            ),
          ),
        ),
      ],
    );
  }
}
