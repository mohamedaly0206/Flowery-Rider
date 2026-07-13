import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/widgets/order_address_label.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/widgets/order_decision_button.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/widgets/order_address_card.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DeliveryOrderCard extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onAccept;
  final OrderEntity order;

  const DeliveryOrderCard({
    required this.onReject,
    required this.onAccept,
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onTertiaryFixedVariant.withValues(
                alpha: 0.15,
              ),
              spreadRadius: 0.3,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalization.flowerOrder,
                style: theme.textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              AddressLabel(label: appLocalization.pickupAddress),
              const SizedBox(height: 8),
              OrderAddressCard(
                title: order.store?.name ?? '',
                address: order.store?.address ?? '',
                imagePath: order.store?.image ?? '',
              ),

              const SizedBox(height: 16),
              AddressLabel(label: appLocalization.userAddress),
              const SizedBox(height: 8),
              OrderAddressCard(
                title: order.user?.firstName ?? '',
                address: order.shippingAddress?.street ?? '',
                imagePath: order.user?.photo ?? '',
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${appLocalization.egp}${order.totalPrice}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: OrderDecisionButton(
                            label: appLocalization.reject,
                            isPrimary: false,
                            onPressed: onReject,
                            orderId: order.id ?? '',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OrderDecisionButton(
                            label: appLocalization.accept,
                            isPrimary: true,
                            onPressed: onAccept,
                            orderId: order.id ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
