import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class OrderCardDetails extends StatelessWidget {
  const OrderCardDetails({
    super.key,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageWidget,
    this.styleTitle,
  });

  final String title;
  final double price;
  final int quantity;
  final Widget imageWidget;
  final TextStyle? styleTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          imageWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.textStyleRegular13.copyWith(
                        color: AppColors.greyColor,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'X$quantity',
                      style: AppTextStyles.textStyleMedium13.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'EGP $price',
                  style: AppTextStyles.textStyleMedium14.copyWith(
                    color: AppColors.blackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
