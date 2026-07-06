import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBuildUploadBox extends StatelessWidget {
  const CustomBuildUploadBox({
    super.key,
    required this.file,
    required this.label,
    required this.hint,
    required this.onTap,
  });

  final dynamic file;
  final String label;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "$label ",
          labelStyle: AppTextStyles.textStyleMedium14.copyWith(
            color: AppColors.greyColor,
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
        ),
        isEmpty: file == null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                file != null ? file.path.split('/').last : hint,
                style: TextStyle(
                  color: file != null
                      ? AppColors.blackColor
                      : AppColors.greyColor,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(Assets.icons.uploadIcon, width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}
