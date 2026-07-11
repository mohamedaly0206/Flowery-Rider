import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomProfileEmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const CustomProfileEmptyState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.person_off_outlined,
            color: AppColors.greyColor,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            'No profile data',
            style: AppTextStyles.textStyleMedium16.copyWith(
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
