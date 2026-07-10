import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/features/order_tracking/presentation/widgets/address_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../order_details/widgets/order_details_card.dart';

class OrderAddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isHaveContact;
  final String? imagePath;
  final VoidCallback? onTap;

  const OrderAddressCard({
    required this.title,
    required this.address,
    this.isHaveContact = false,
    this.onTap,
    super.key,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: OrderDetailsCard(
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
                      _ContactIcon(assetName: Assets.icons.coloredCallIcon,),
                      SizedBox(width: 10),
                      _ContactIcon(assetName: Assets.icons.whatsappIcon,isWhatsAppIcon: true,),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _ContactIcon extends StatelessWidget {
  final String assetName;
  final  bool isWhatsAppIcon;

  const  _ContactIcon({required this.assetName,this.isWhatsAppIcon = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: isWhatsAppIcon?20:16,
      height:isWhatsAppIcon?20: 16,
      
    );
  }
}
