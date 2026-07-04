import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileInfoCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final List<String> subtitles;
  final VoidCallback? onTap;

  const ProfileInfoCard({
    super.key,
    this.leading,
    required this.title,
    required this.subtitles,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.dividerColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 16)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textStyleMedium18.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  for (final subtitle in subtitles)
                    if (subtitle.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.textStyleRegular16.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            SvgPicture.asset(Assets.icons.arrowForward),
          ],
        ),
      ),
    );
  }
}
