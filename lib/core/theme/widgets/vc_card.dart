// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Modern Material 3 card component for Squeak app
class VcCard extends StatelessWidget {
  const VcCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation,
    this.color,
    this.borderRadius,
    this.onTap,
    this.showBorder = false,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radius12),
        border: showBorder
            ? Border.all(
                color: borderColor ?? theme.colorScheme.outline,
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
            blurRadius: elevation ?? AppTheme.elevation1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radius12),
        child: content,
      );
    }

    return Container(
      margin: margin ?? const EdgeInsets.all(AppTheme.spacing8),
      child: content,
    );
  }
}

/// Specialized card for pet information display
class VcPetCard extends StatelessWidget {
  const VcPetCard({
    super.key,
    required this.child,
    this.petAvatar,
    this.petName,
    this.healthStatus,
    this.onTap,
    this.badges = const [],
  });

  final Widget child;
  final Widget? petAvatar;
  final String? petName;
  final PetHealthStatus? healthStatus;
  final VoidCallback? onTap;
  final List<Widget> badges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return VcCard(
      onTap: onTap,
      showBorder: healthStatus != null,
      borderColor: _getHealthStatusColor(healthStatus, theme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (petAvatar != null || petName != null || badges.isNotEmpty)
            Row(
              children: [
                if (petAvatar != null) ...[
                  petAvatar!,
                  const SizedBox(width: AppTheme.spacing12),
                ],
                if (petName != null)
                  Expanded(
                    child: Text(
                      petName!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (badges.isNotEmpty) ...badges,
                if (healthStatus != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing8,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: _getHealthStatusColor(healthStatus, theme)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radius8),
                    ),
                    child: Text(
                      _getHealthStatusText(healthStatus!),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getHealthStatusColor(healthStatus, theme),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          if ((petAvatar != null || petName != null || badges.isNotEmpty) &&
              child != const SizedBox.shrink())
            const SizedBox(height: AppTheme.spacing12),
          child,
        ],
      ),
    );
  }

  Color _getHealthStatusColor(PetHealthStatus? status, ThemeData theme) {
    switch (status) {
      case PetHealthStatus.healthy:
        return AppTheme.petHealthyColor;
      case PetHealthStatus.warning:
        return AppTheme.petWarningColor;
      case PetHealthStatus.emergency:
        return AppTheme.petEmergencyColor;
      case PetHealthStatus.vaccination:
        return AppTheme.petVaccinationColor;
      case PetHealthStatus.treatment:
        return AppTheme.petTreatmentColor;
      case null:
        return theme.colorScheme.outline;
    }
  }

  String _getHealthStatusText(PetHealthStatus status) {
    switch (status) {
      case PetHealthStatus.healthy:
        return 'Healthy';
      case PetHealthStatus.warning:
        return 'Attention';
      case PetHealthStatus.emergency:
        return 'Urgent';
      case PetHealthStatus.vaccination:
        return 'Vaccination';
      case PetHealthStatus.treatment:
        return 'Treatment';
    }
  }
}

/// Pet health status enum
enum PetHealthStatus {
  healthy,
  warning,
  emergency,
  vaccination,
  treatment,
}
