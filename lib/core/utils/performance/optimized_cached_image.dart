// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import '../../theme/app_theme.dart';

/// Performance-optimized cached network image widget
class OptimizedCachedImage extends StatelessWidget {
  const OptimizedCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.memCacheHeight,
    this.memCacheWidth,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final int? memCacheHeight;
  final int? memCacheWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget image = SafeFastCachedImageExtension.safe(
      url: imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder:
          (context, progress) => placeholder ?? _buildDefaultPlaceholder(theme),
      errorBuilder:
          (context, exception, stacktrace) =>
              errorWidget ?? _buildDefaultError(theme),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _buildDefaultPlaceholder(ThemeData theme) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultError(ThemeData theme) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: borderRadius,
      ),
      child: Icon(
        Icons.broken_image,
        color: theme.colorScheme.onErrorContainer,
        size:
            (width != null && height != null)
                ? (width! < height! ? width! * 0.3 : height! * 0.3)
                : 24,
      ),
    );
  }
}

/// Optimized avatar image with fallback
class OptimizedAvatarImage extends StatelessWidget {
  const OptimizedAvatarImage({
    super.key,
    required this.imageUrl,
    required this.size,
    this.initials,
    this.backgroundColor,
  });

  final String? imageUrl;
  final double size;
  final String? initials;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return OptimizedCachedImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(size / 2),
        errorWidget: _buildFallback(theme),
        placeholder: _buildFallback(theme),
      );
    }

    return _buildFallback(theme);
  }

  Widget _buildFallback(ThemeData theme) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.petAvatarColors.first,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials ?? 'P',
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Hero image with optimized loading
class OptimizedHeroImage extends StatelessWidget {
  const OptimizedHeroImage({
    super.key,
    required this.imageUrl,
    required this.tag,
    this.width,
    this.height,
    this.onTap,
  });

  final String imageUrl;
  final String tag;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: onTap,
        child: OptimizedCachedImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(AppTheme.radius12),
        ),
      ),
    );
  }
}
