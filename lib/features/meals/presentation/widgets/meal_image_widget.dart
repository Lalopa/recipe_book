import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MealImageWidget extends StatelessWidget {
  const MealImageWidget({
    required this.imageUrl,
    this.width = 56,
    this.height = 56,
    this.borderRadius = 8.0,
    this.bottomBorderRadius,
    super.key,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final double? bottomBorderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(borderRadius),
        bottom: Radius.circular(bottomBorderRadius ?? 0),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: BoxFit.fill,
        placeholder: (context, url) => _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
        memCacheWidth: (width * 2).toInt(),
        memCacheHeight: (height * 2).toInt(),
        maxWidthDiskCache: (width * 2).toInt(),
        maxHeightDiskCache: (height * 2).toInt(),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        Icons.restaurant,
        color: Colors.grey[600],
        size: width * 0.4,
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        Icons.broken_image,
        color: Colors.grey[600],
        size: width * 0.4,
      ),
    );
  }
}
