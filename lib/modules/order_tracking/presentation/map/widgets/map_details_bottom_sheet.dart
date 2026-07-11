import 'package:flowery_rider/modules/order_tracking/domain/entities/map_route_args.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/widgets/order_address_card.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MapDetailsBottomSheet extends StatelessWidget {
  final OrderEntity order;
  final MapRoutePointType type;
final ScrollController scrollController;
  const MapDetailsBottomSheet({
    super.key,
    required this.order,
    required this.type,
        required this.scrollController,

  });

  @override
  Widget build(BuildContext context) {
    final isStore = type == MapRoutePointType.store;
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

  return Container(
  decoration: BoxDecoration(
    color: theme.colorScheme.onPrimary,
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(24),
    ),
  ),
  child: ListView(
    controller: scrollController,
    padding: const EdgeInsets.all(16),
    children: [
      Center(
        child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
            const SizedBox(height: 20),

            if (isStore) ...[
              Text(
                localization.pickupAddress,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
              SizedBox(height: 8),
              OrderAddressCard(
                title: order.store?.name ?? '',
                address: order.store?.address ?? '',
                imagePath: order.store?.image ?? '',
                isHaveContact: true,
              ),
              const SizedBox(height: 24),
              Text(
                localization.userAddress,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
              SizedBox(height: 8),
              OrderAddressCard(
                title: order.user?.firstName ?? '',
                address: order.shippingAddress?.street ?? '',
                imagePath: order.user?.photo ?? '',
                isHaveContact: true,
              ),
            ] else ...[
              Text(
                localization.userAddress,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
              SizedBox(height: 8),
              OrderAddressCard(
                title: order.user?.firstName ?? '',
                address: order.shippingAddress?.street ?? '',
                imagePath: order.user?.photo ?? '',
                isHaveContact: true,
              ),

              const SizedBox(height: 16),
              Text(
                localization.pickupAddress,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
              SizedBox(height: 8),
              OrderAddressCard(
                title: order.store?.name ?? '',
                address: order.store?.address ?? '',
                imagePath: order.store?.image ?? '',
                isHaveContact: true,
              ),
            ],
          ],
        ),
      );
    
  }
}
