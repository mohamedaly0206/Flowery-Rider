import 'package:flutter/material.dart';

class AddressLabel extends StatelessWidget {
  final String label;

  const AddressLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onInverseSurface,
      ),
    );
  }
}
