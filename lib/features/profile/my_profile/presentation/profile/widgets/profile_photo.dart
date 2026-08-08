import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  final String photoUrl;

  const ProfilePhoto({super.key, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 56,
        height: 56,
        child: photoUrl.isEmpty
            ? const ColoredBox(
                color: AppColors.dividerColor,
                child: Icon(Icons.person, color: AppColors.greyColor),
              )
            : CachedNetworkImage(
                imageUrl: photoUrl.contains('?')
                    ? '$photoUrl&v=${DateTime.now().millisecondsSinceEpoch}'
                    : '$photoUrl?v=${DateTime.now().millisecondsSinceEpoch}',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const ColoredBox(
                  color: AppColors.dividerColor,
                  child: Icon(Icons.person, color: AppColors.greyColor),
                ),
              ),
      ),
    );
  }
}
