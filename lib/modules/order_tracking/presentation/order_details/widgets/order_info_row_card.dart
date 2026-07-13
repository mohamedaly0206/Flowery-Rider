import 'package:flutter/material.dart';
import 'order_details_card.dart';

class OrderInfoRowCard extends StatelessWidget {
  final String title;
  final String value;

  const OrderInfoRowCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OrderDetailsCard(
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.headlineMedium)),
          Text(
            value,
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.colorScheme.onInverseSurface,
            ),
          ),
        ],
      ),
    );
  }
}
