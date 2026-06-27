import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/order_status/order_details_status.dart';
import 'order_details_card.dart';

class OrderStatusCard extends StatelessWidget {
  final OrderDetailsStatus status;
  final String orderId;
  final String date;

  const OrderStatusCard({
    required this.status,
    super.key,
    required this.orderId,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocalizations=AppLocalizations.of(context)!;
    return OrderDetailsCard(
      color: AppColors.secondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${appLocalizations.status} ${status.label(appLocalizations)}',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${appLocalizations.orderId} # $orderId',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.colorScheme.onInverseSurface,
            ),
          ),
        ],
      ),
    );
  }
}
