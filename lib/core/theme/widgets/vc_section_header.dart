import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Modern section header component for organizing content
class VcSectionHeader extends StatelessWidget {
  const VcSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.icon,
    this.showDivider = true,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final Widget? icon;
  final bool showDivider;
  final EdgeInsets? padding;

  /// Factory for simple section header with just title
  factory VcSectionHeader.simple(String title) {
    return VcSectionHeader(title: title);
  }

  /// Factory for section header with action button
  factory VcSectionHeader.withAction({
    required String title,
    String? subtitle,
    required Widget action,
    Widget? icon,
  }) {
    return VcSectionHeader(
      title: title,
      subtitle: subtitle,
      action: action,
      icon: icon,
    );
  }

  /// Factory for collapsible section header
  factory VcSectionHeader.collapsible({
    required String title,
    String? subtitle,
    required bool isExpanded,
    required VoidCallback onToggle,
    Widget? icon,
  }) {
    return VcSectionHeader(
      title: title,
      subtitle: subtitle,
      icon: icon,
      action: IconButton(
        icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
        onPressed: onToggle,
        tooltip: isExpanded ? 'Collapse' : 'Expand',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppTheme.spacing12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
          if (showDivider) ...[
            const SizedBox(height: AppTheme.spacing12),
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ],
        ],
      ),
    );
  }
}

/// Pet-focused section header with health status indicator
class VcPetSectionHeader extends StatelessWidget {
  const VcPetSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.petCount,
    this.healthyCount,
    this.alertCount,
    this.showHealthSummary = true,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final int? petCount;
  final int? healthyCount;
  final int? alertCount;
  final bool showHealthSummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return VcSectionHeader(
      title: title,
      subtitle: _buildSubtitle(theme),
      action: action,
      icon: Icon(
        Icons.pets,
        color: theme.colorScheme.primary,
      ),
    );
  }

  String? _buildSubtitle(ThemeData theme) {
    if (!showHealthSummary || petCount == null) return subtitle;
    
    final parts = <String>[];
    
    if (petCount! > 0) {
      parts.add('$petCount ${petCount == 1 ? 'pet' : 'pets'}');
    }
    
    if (healthyCount != null && healthyCount! > 0) {
      parts.add('$healthyCount healthy');
    }
    
    if (alertCount != null && alertCount! > 0) {
      parts.add('$alertCount need attention');
    }
    
    if (parts.isEmpty) return subtitle;
    
    final summary = parts.join(' • ');
    return subtitle != null ? '$subtitle\n$summary' : summary;
  }
}
