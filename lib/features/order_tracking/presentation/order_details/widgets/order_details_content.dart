import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/widgets/order_info_row_card.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/widgets/order_item_card.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/widgets/title_section.dart';
import 'package:flowery_rider/features/order_tracking/presentation/widgets/order_address_card.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class OrderDetailsContent extends StatelessWidget {
  final OrderEntity? order;
  final VoidCallback onPickupAddressTap;
  final VoidCallback onUserAddressTap;

  const OrderDetailsContent({
    required this.order,
    required this.onPickupAddressTap,
    required this.onUserAddressTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final order = this.order;

    if (order == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSection(title: localizations.pickupAddress),
          const SizedBox(height: 16),
          OrderAddressCard(
            title: order.store?.name ?? '',
            address: order.store?.address ?? '',
            imagePath: order.store?.image ?? '',
            isHaveContact: true,
            onTap: onPickupAddressTap,
          ),
          const SizedBox(height: 24),
          TitleSection(title: localizations.userAddress),
          const SizedBox(height: 16),
          OrderAddressCard(
            title: order.user?.firstName ?? '',
            address: order.shippingAddress?.street ?? '',
            imagePath: order.user?.photo ?? '',
            isHaveContact: true,
            onTap: onUserAddressTap,
          ),
          const SizedBox(height: 24),
          TitleSection(title: localizations.orderDetails),
          const SizedBox(height: 16),
          ...?order.orderItems?.map(
            (item) => OrderItemCard(
              title: item.product?.title ?? '',
              price: item.price?.toString() ?? '',
              quantity: '${item.quantity ?? 0}x',
              imagePath: item.product?.imgCover ?? '',
            ),
          ),
          OrderInfoRowCard(
            title: localizations.total,
            value: '${localizations.egp} ${order.totalPrice.toString()}',
          ),
          const SizedBox(height: 8),
          OrderInfoRowCard(
            title: localizations.paymentMethod,
            value: order.paymentType ?? '',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
