import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/widgets/custom_address_section.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/widgets/custom_default_card.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/widgets/order_card_details.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrderDetailView extends StatelessWidget {
  final DriverOrderEntity orderEntity;

  const OrderDetailView({super.key, required this.orderEntity});

  @override
  Widget build(BuildContext context) {
    final orderId = orderEntity.order?.id?.substring(0, 6) ?? '';
    final orderState = orderEntity.order?.state ?? 'completed';
    final isCancelled = orderState == 'canceled';

    final products = orderEntity.order!.orderItems ?? [];
    final totalPrice = orderEntity.order?.totalPrice ?? '0';
    final paymentMethod = orderEntity.order?.paymentType ?? '';
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.orderDetails,
        hasBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      isCancelled
                          ? Assets.icons.cancelIcon
                          : Assets.icons.checkCircleIcon,
                      colorFilter: ColorFilter.mode(
                        isCancelled
                            ? AppColors.errorColor
                            : AppColors.successColor,
                        BlendMode.srcIn,
                      ),
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
                  ],
                ),
                Text('#$orderId', style: AppTextStyles.textStyleSemiBold20),
              ],
            ),
            const SizedBox(height: 20),

            CustomAddressSection(
              title: localizations.pickupAddress,
              styleTitle: AppTextStyles.textStyleMedium18.copyWith(
                color: AppColors.blackColor,
              ),
              storeName: orderEntity.store!.name ?? '',
              address: orderEntity.store!.address ?? '',
              imageWidget: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(orderEntity.store!.image!),
              ),
            ),
            const SizedBox(height: 20),

            CustomAddressSection(
              title: localizations.userAddress,
              styleTitle: AppTextStyles.textStyleMedium18.copyWith(
                color: AppColors.blackColor,
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
            const SizedBox(height: 24),

            Text(
              localizations.orderDetails,
              style: AppTextStyles.textStyleMedium18.copyWith(
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.isEmpty ? 2 : products.length,

              itemBuilder: (context, index) {
                return OrderCardDetails(
                  quantity: orderEntity.order!.orderItems![index].quantity ?? 0,
                  title:
                      '${orderEntity.order!.user!.firstName ?? ''} ${orderEntity.order!.user!.lastName ?? ''}',
                  price: orderEntity.order!.orderItems![index].price ?? 0,
                  imageWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      orderEntity.store!.image ??
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
                );
              },
            ),
            const SizedBox(height: 14),

            CustomDefaultCard(
              title: localizations.total,
              subTitle: '${totalPrice.toString()} EGP',
            ),
            const SizedBox(height: 12),
            CustomDefaultCard(
              title: localizations.paymentMethod,
              subTitle: paymentMethod,
            ),
          ],
        ),
      ),
    );
  }
}
