import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
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
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: status.isDelivered ? null : onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColors.placeHolderColor,
        ),
        child: Text(status.actionLabel as String),
      ),
    );
  }
}
