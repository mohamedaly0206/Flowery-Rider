import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowery_rider/core/values/fonts.gen.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import 'order_details_card.dart';

class OrderItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String quantity;
  final String imagePath;

  const OrderItemCard({
    required this.title,
    required this.price,
    required this.quantity,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OrderDetailsCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onInverseSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${AppLocalizations.of(context)!.egp} $price",
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontFamily: FontFamily.roboto,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              quantity,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.primaryColor,
                fontFamily: FontFamily.roboto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
