import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/features/order_tracking/presentation/widgets/address_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../order_details/widgets/order_details_card.dart';

class OrderAddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isHaveContact;
  final String? imagePath;

  const OrderAddressCard({
    required this.title,
    required this.address,
    this.isHaveContact = false,
    super.key,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OrderDetailsCard(
      child: Row(
        children: [
          AddressAvatar(imagePath: imagePath ?? ''),
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
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.icons.locationOnIcon,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          isHaveContact
              ? Row(
                  children: [
                    SizedBox(width: 8),
                    _ContactIcon(assetName: Assets.icons.callIcon),
                    SizedBox(width: 10),
                    _ContactIcon(assetName: Assets.icons.whatsappIcon),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _ContactIcon extends StatelessWidget {
  final String assetName;

  const _ContactIcon({required this.assetName});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: 16,
      height: 16,
      colorFilter: const ColorFilter.mode(
        AppColors.primaryColor,
        BlendMode.srcIn,
      ),
    );
  }
}
