import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/views/order_detail_view.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/widgets/custom_address_section.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderCardItem extends StatelessWidget {
  final DriverOrderEntity orderEntity;

  const OrderCardItem({super.key, required this.orderEntity});

  @override
  Widget build(BuildContext context) {
    final orderId = orderEntity.order?.id?.substring(0, 6) ?? '';
    final orderState = orderEntity.order?.state ?? AppStrings.completedCa;
    final isCancelled = orderState == 'canceled';
    final localizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailView(orderEntity: orderEntity),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.flowerOrder,
                  style: AppTextStyles.textStyleMedium14,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SvgPicture.asset(
                  isCancelled
                      ? Assets.icons.cancelIcon
                      : Assets.icons.checkCircleIcon,
                  color: isCancelled
                      ? AppColors.errorColor
                      : AppColors.successColor,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 6),
                Text(
                  isCancelled
                      ? localizations.cancelled
                      : localizations.completed,
                  style: AppTextStyles.textStyleMedium16.copyWith(
                    color: isCancelled
                        ? AppColors.errorColor
                        : AppColors.successColor,
                  ),
                ),
                Spacer(),
                Text('#$orderId', style: AppTextStyles.textStyleSemiBold20),
              ],
            ),
            const SizedBox(height: 16),

            CustomAddressSection(
              title: localizations.pickupAddress,
              storeName: orderEntity.store!.name ?? '',
              address: orderEntity.store!.address ?? '',
              imageWidget: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(orderEntity.store!.image!),
              ),
            ),
            const SizedBox(height: 16),

            CustomAddressSection(
              title: localizations.userAddress,
              styleTitle: AppTextStyles.textStyleRegular14.copyWith(
                color: AppColors.greyColor,
              ),
              storeName:
                  '${orderEntity.order!.user!.firstName ?? ''} ${orderEntity.order!.user!.lastName ?? ''}',
              address: orderEntity.store!.address ?? '',
              imageWidget: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  orderEntity.order!.user!.photo ??
                      'https://cdn.pixabay.com/photo/2014/03/24/13/49/avatar-294480_1280.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 36,
                    height: 36,
                    color: AppColors.greyColor.withValues(alpha: 0.3),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
