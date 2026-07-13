import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/order_status/order_details_status.dart';

class OrderActionButton extends StatelessWidget {
  final OrderDetailsStatus status;
  final VoidCallback? onPressed;

  const OrderActionButton({
    required this.status,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: status.isDelivered ? null : onPressed,
        style: ElevatedButton.styleFrom().copyWith(
          backgroundColor: WidgetStateProperty.all(
            status.isDelivered
                ? theme.colorScheme.onSecondaryFixedVariant
                : theme.colorScheme.primary,
          ),
        ),
        child: Text(
          status.actionLabel(AppLocalizations.of(context)!),
          style: theme.textTheme.headlineMedium?.copyWith(
            color: status.isDelivered
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
