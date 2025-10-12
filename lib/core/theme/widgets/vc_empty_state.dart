// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Modern empty state component with actions and illustrations
class VcEmptyState extends StatelessWidget {
  const VcEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.illustration,
    this.action,
    this.secondaryAction,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? illustration;
  final Widget? action;
  final Widget? secondaryAction;
  final EdgeInsets? padding;

  /// Factory for pet-related empty states
  factory VcEmptyState.pets({
    Key? key,
    String title = 'No pets yet',
    String? subtitle = 'Add your first pet to get started with tracking their health and appointments.',
    VoidCallback? onAddPet,
  }) {
    return VcEmptyState(
      key: key,
      title: title,
      subtitle: subtitle,
      illustration: _PetIllustration(),
      action: onAddPet != null
          ? ElevatedButton.icon(
              onPressed: onAddPet,
              icon: const Icon(Icons.add),
              label: const Text('Add Pet'),
            )
          : null,
    );
  }

  /// Factory for appointments empty state
  factory VcEmptyState.appointments({
    Key? key,
    String title = 'No appointments',
    String? subtitle = 'Schedule your first appointment to keep your pets healthy.',
    VoidCallback? onSchedule,
  }) {
    return VcEmptyState(
      key: key,
      title: title,
      subtitle: subtitle,
      illustration: _AppointmentIllustration(),
      action: onSchedule != null
          ? ElevatedButton.icon(
              onPressed: onSchedule,
              icon: const Icon(Icons.schedule),
              label: const Text('Schedule Appointment'),
            )
          : null,
    );
  }

  /// Factory for search results empty state
  factory VcEmptyState.search({
    Key? key,
    String title = 'No results found',
    String? subtitle = 'Try adjusting your search terms or filters.',
    VoidCallback? onClear,
  }) {
    return VcEmptyState(
      key: key,
      title: title,
      subtitle: subtitle,
      illustration: _SearchIllustration(),
      action: onClear != null
          ? TextButton(
              onPressed: onClear,
              child: const Text('Clear Search'),
            )
          : null,
    );
  }

  /// Factory for error states
  factory VcEmptyState.error({
    Key? key,
    String title = 'Something went wrong',
    String? subtitle = 'Please try again or contact support if the problem persists.',
    VoidCallback? onRetry,
  }) {
    return VcEmptyState(
      key: key,
      title: title,
      subtitle: subtitle,
      illustration: _ErrorIllustration(),
      action: onRetry != null
          ? ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            )
          : null,
    );
  }

  /// Factory for offline state
  factory VcEmptyState.offline({
    Key? key,
    String title = 'No internet connection',
    String? subtitle = 'Check your connection and try again.',
    VoidCallback? onRetry,
  }) {
    return VcEmptyState(
      key: key,
      title: title,
      subtitle: subtitle,
      illustration: _OfflineIllustration(),
      action: onRetry != null
          ? OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (illustration != null) ...[
            illustration!,
            const SizedBox(height: AppTheme.spacing24),
          ],
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacing12),
            Text(
              subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null || secondaryAction != null) ...[
            const SizedBox(height: AppTheme.spacing24),
            if (action != null) action!,
            if (secondaryAction != null) ...[
              const SizedBox(height: AppTheme.spacing12),
              secondaryAction!,
            ],
          ],
        ],
      ),
    );
  }
}

/// Pet illustration for empty states
class _PetIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.pets,
        size: 48,
        color: theme.colorScheme.primary.withOpacity(0.7),
      ),
    );
  }
}

/// Appointment illustration for empty states
class _AppointmentIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.event_note,
        size: 48,
        color: theme.colorScheme.secondary.withOpacity(0.7),
      ),
    );
  }
}

/// Search illustration for empty states
class _SearchIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.search_off,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Error illustration for empty states
class _ErrorIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline,
        size: 48,
        color: theme.colorScheme.error.withOpacity(0.7),
      ),
    );
  }
}

/// Offline illustration for empty states
class _OfflineIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.wifi_off,
        size: 48,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
