import 'package:flutter/material.dart';

Future<T?> showCustomAlertDialog<T>({
  required BuildContext context,
  IconData? icon,
  required String title,
  String? message,
  required String primaryButtonText,
  required VoidCallback onPrimaryPressed,
  required String secondaryButtonText,
  VoidCallback? onSecondaryPressed,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: theme.colorScheme.onSecondary,
        title: icon == null
            ? null
            : Icon(icon, color: theme.colorScheme.primary, size: 48),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.headlineLarge),
            Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    // Defaults to just popping the dialog if no custom action is passed
                    onPressed:
                        onSecondaryPressed ?? () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.onSecondary,
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                    child: Text(
                      secondaryButtonText,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryPressed,
                    child: Text(
                      primaryButtonText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
