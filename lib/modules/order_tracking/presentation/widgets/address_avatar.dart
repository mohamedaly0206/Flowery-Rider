import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AddressAvatar extends StatelessWidget {
  final String imagePath;

  static const String _baseUrl = "https://flower.elevateegy.com/uploads/";

  const AddressAvatar({required this.imagePath, super.key});

  String get _fullImageUrl {
    if (imagePath.isEmpty) return "";

    if (imagePath.startsWith('http')) return imagePath;

    return "$_baseUrl$imagePath";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: _fullImageUrl,
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
    );
  }
}
