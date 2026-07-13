import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAddressSection extends StatelessWidget {
  const CustomAddressSection({
    super.key,
    required this.title,
    required this.storeName,
    required this.address,
    required this.imageWidget,
    this.styleTitle,
  });

  final String title;
  final String storeName;
  final String address;
  final Widget imageWidget;
  final TextStyle? styleTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: styleTitle),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.greyColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              imageWidget,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: AppTextStyles.textStyleRegular13.copyWith(
                        color: AppColors.greyColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          Assets.icons.locationIcon,
                          colorFilter: ColorFilter.mode(
                            AppColors.blackColor,
                            BlendMode.srcIn,
                          ),
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            address,
                            style: AppTextStyles.textStyleRegular13.copyWith(
                              color: AppColors.blackColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
