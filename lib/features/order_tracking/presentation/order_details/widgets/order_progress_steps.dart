import 'package:flutter/material.dart';

class OrderProgressSteps extends StatelessWidget {
  final int completedSteps;
  final int totalSteps;

  const OrderProgressSteps({
    required this.completedSteps,
    this.totalSteps = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index <= completedSteps;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsetsDirectional.only(
              end: index == totalSteps ? 0 : 8,
            ),
            decoration: BoxDecoration(
              color: isCompleted
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.onTertiaryFixed,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }),
    );
  }
}
