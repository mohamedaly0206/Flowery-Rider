import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;

  const TitleSection({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
