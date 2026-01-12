// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import '../../app_theme.dart';

/// Pet avatar component with breed-specific placeholders
class PetAvatar extends StatelessWidget {
  const PetAvatar({
    super.key,
    this.imageUrl,
    this.petName,
    this.petBreed,
    this.size = PetAvatarSize.medium,
    this.showBadge = false,
    this.badgeIcon,
    this.onTap,
  });

  final String? imageUrl;
  final String? petName;
  final String? petBreed;
  final PetAvatarSize size;
  final bool showBadge;
  final Widget? badgeIcon;
  final VoidCallback? onTap;

  /// Factory for small avatar (list items)
  factory PetAvatar.small({
    Key? key,
    String? imageUrl,
    String? petName,
    String? petBreed,
    bool showBadge = false,
    Widget? badgeIcon,
    VoidCallback? onTap,
  }) {
    return PetAvatar(
      key: key,
      imageUrl: imageUrl,
      petName: petName,
      petBreed: petBreed,
      size: PetAvatarSize.small,
      showBadge: showBadge,
      badgeIcon: badgeIcon,
      onTap: onTap,
    );
  }

  /// Factory for large avatar (profile pages)
  factory PetAvatar.large({
    Key? key,
    String? imageUrl,
    String? petName,
    String? petBreed,
    bool showBadge = false,
    Widget? badgeIcon,
    VoidCallback? onTap,
  }) {
    return PetAvatar(
      key: key,
      imageUrl: imageUrl,
      petName: petName,
      petBreed: petBreed,
      size: PetAvatarSize.large,
      showBadge: showBadge,
      badgeIcon: badgeIcon,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarSize = _getAvatarSize(size);

    Widget avatar = Container(
      width: avatarSize.diameter,
      height: avatarSize.diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBreedColor(),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child:
            imageUrl != null && imageUrl!.isNotEmpty
                ? SafeFastCachedImageExtension.safe(
                  url: imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (context, progress) =>
                          _buildPlaceholder(theme, avatarSize),
                  errorBuilder:
                      (context, exception, stacktrace) =>
                          _buildPlaceholder(theme, avatarSize),
                )
                : _buildPlaceholder(theme, avatarSize),
      ),
    );

    // Add badge if needed
    if (showBadge && badgeIcon != null) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: avatarSize.badgeSize,
              height: avatarSize.badgeSize,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 2),
              ),
              child: Center(
                child: IconTheme(
                  data: IconThemeData(
                    color: theme.colorScheme.onPrimary,
                    size: avatarSize.badgeIconSize,
                  ),
                  child: badgeIcon!,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Add tap functionality
    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    return avatar;
  }

  Widget _buildPlaceholder(ThemeData theme, _AvatarSize avatarSize) {
    return Container(
      width: avatarSize.diameter,
      height: avatarSize.diameter,
      color: _getBreedColor(),
      child: Center(
        child: Icon(
          Icons.pets,
          color: Colors.white,
          size: avatarSize.fontSize + 4,
        ),
      ),
    );
  }

  Color _getBreedColor() {
    if (petBreed != null) {
      final hash = petBreed!.hashCode;
      final colorIndex = hash.abs() % AppTheme.petAvatarColors.length;
      return AppTheme.petAvatarColors[colorIndex];
    }
    return AppTheme.petAvatarColors.first;
  }

  _AvatarSize _getAvatarSize(PetAvatarSize size) {
    switch (size) {
      case PetAvatarSize.small:
        return const _AvatarSize(
          diameter: 32,
          fontSize: 12,
          badgeSize: 12,
          badgeIconSize: 8,
        );
      case PetAvatarSize.medium:
        return const _AvatarSize(
          diameter: 48,
          fontSize: 16,
          badgeSize: 16,
          badgeIconSize: 12,
        );
      case PetAvatarSize.large:
        return const _AvatarSize(
          diameter: 80,
          fontSize: 24,
          badgeSize: 24,
          badgeIconSize: 16,
        );
      case PetAvatarSize.xlarge:
        return const _AvatarSize(
          diameter: 120,
          fontSize: 32,
          badgeSize: 32,
          badgeIconSize: 20,
        );
    }
  }
}

/// Pet avatar size variants
enum PetAvatarSize { small, medium, large, xlarge }

/// Internal avatar size configuration
class _AvatarSize {
  const _AvatarSize({
    required this.diameter,
    required this.fontSize,
    required this.badgeSize,
    required this.badgeIconSize,
  });

  final double diameter;
  final double fontSize;
  final double badgeSize;
  final double badgeIconSize;
}
