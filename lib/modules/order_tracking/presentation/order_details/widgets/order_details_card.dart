import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class OrderDetailsCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const OrderDetailsCard({
    required this.child,
    this.color = AppColors.whiteColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onTertiaryFixedVariant.withValues(alpha: 0.15),
            spreadRadius: 0.3,
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
