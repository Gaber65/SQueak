// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// Pet achievement badges for gamification
class PetBadge extends StatelessWidget {
  const PetBadge({
    super.key,
    required this.type,
    this.size = PetBadgeSize.medium,
    this.label,
    this.showLabel = true,
  });

  final PetBadgeType type;
  final PetBadgeSize size;
  final String? label;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeInfo = _getBadgeInfo(type);
    final badgeSize = _getBadgeSize(size);
    
    Widget badge = Container(
      width: badgeSize.diameter,
      height: badgeSize.diameter,
      decoration: BoxDecoration(
        color: badgeInfo.color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeInfo.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          badgeInfo.icon,
          size: badgeSize.iconSize,
          color: Colors.white,
        ),
      ),
    );

    if (showLabel && (label != null || badgeInfo.defaultLabel != null)) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge,
          const SizedBox(height: AppTheme.spacing4),
          Text(
            label ?? badgeInfo.defaultLabel!,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return badge;
  }

  _BadgeInfo _getBadgeInfo(PetBadgeType type) {
    switch (type) {
      case PetBadgeType.healthyPup:
        return const _BadgeInfo(
          color: AppTheme.petHealthyColor,
          icon: Icons.favorite,
          defaultLabel: 'Healthy Pup',
        );
      case PetBadgeType.vaccinationStar:
        return const _BadgeInfo(
          color: AppTheme.petVaccinationColor,
          icon: Icons.vaccines,
          defaultLabel: 'Vaccination Star',
        );
      case PetBadgeType.appointmentKeeper:
        return const _BadgeInfo(
          color: Color(0xFF2196F3),
          icon: Icons.schedule,
          defaultLabel: 'Appointment Keeper',
        );
      case PetBadgeType.treatmentChampion:
        return const _BadgeInfo(
          color: AppTheme.petTreatmentColor,
          icon: Icons.medical_services,
          defaultLabel: 'Treatment Champion',
        );
      case PetBadgeType.wellnessWarrior:
        return const _BadgeInfo(
          color: AppTheme.badgeGoldColor,
          icon: Icons.workspace_premium,
          defaultLabel: 'Wellness Warrior',
        );
      case PetBadgeType.newPetParent:
        return const _BadgeInfo(
          color: Color(0xFFFF9800),
          icon: Icons.family_restroom,
          defaultLabel: 'New Pet Parent',
        );
      case PetBadgeType.careExpert:
        return const _BadgeInfo(
          color: AppTheme.badgeSilverColor,
          icon: Icons.psychology,
          defaultLabel: 'Care Expert',
        );
      case PetBadgeType.loyalCompanion:
        return const _BadgeInfo(
          color: Color(0xFFE91E63),
          icon: Icons.pets,
          defaultLabel: 'Loyal Companion',
        );
    }
  }

  _BadgeSize _getBadgeSize(PetBadgeSize size) {
    switch (size) {
      case PetBadgeSize.small:
        return const _BadgeSize(diameter: 24, iconSize: 12);
      case PetBadgeSize.medium:
        return const _BadgeSize(diameter: 32, iconSize: 16);
      case PetBadgeSize.large:
        return const _BadgeSize(diameter: 48, iconSize: 24);
    }
  }
}

/// Collection of badges for display
class PetBadgeRow extends StatelessWidget {
  const PetBadgeRow({
    super.key,
    required this.badges,
    this.spacing = AppTheme.spacing8,
    this.maxVisible = 4,
    this.showLabels = false,
  });

  final List<PetBadgeType> badges;
  final double spacing;
  final int maxVisible;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleBadges = badges.take(maxVisible).toList();
    final remainingCount = badges.length - maxVisible;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...visibleBadges.map((badge) => [
          PetBadge(
            type: badge,
            size: PetBadgeSize.small,
            showLabel: showLabels,
          ),
          if (badge != visibleBadges.last) SizedBox(width: spacing),
        ]).expand((element) => element),
        
        if (remainingCount > 0) ...[
          SizedBox(width: spacing),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Badge types for different achievements
enum PetBadgeType {
  healthyPup,
  vaccinationStar,
  appointmentKeeper,
  treatmentChampion,
  wellnessWarrior,
  newPetParent,
  careExpert,
  loyalCompanion,
}

/// Badge size variants
enum PetBadgeSize { small, medium, large }

/// Internal badge information
class _BadgeInfo {
  const _BadgeInfo({
    required this.color,
    required this.icon,
    this.defaultLabel,
  });

  final Color color;
  final IconData icon;
  final String? defaultLabel;
}

/// Internal badge size configuration
class _BadgeSize {
  const _BadgeSize({
    required this.diameter,
    required this.iconSize,
  });

  final double diameter;
  final double iconSize;
}
