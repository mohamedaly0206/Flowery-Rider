import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? trailingText;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.textStyleRegular14.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: AppTextStyles.textStyleRegular12.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
