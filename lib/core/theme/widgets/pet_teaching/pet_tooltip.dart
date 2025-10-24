// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../app_theme.dart';

/// Interactive tooltip component for pet care guidance
class PetTooltip extends StatefulWidget {
  const PetTooltip({
    super.key,
    required this.message,
    required this.child,
    this.title,
    this.icon,
    this.isDismissible = true,
    this.onDismiss,
    this.placement = TooltipPlacement.auto,
    this.showDelay = const Duration(milliseconds: 500),
  });

  final String message;
  final Widget child;
  final String? title;
  final Widget? icon;
  final bool isDismissible;
  final VoidCallback? onDismiss;
  final TooltipPlacement placement;
  final Duration showDelay;

  /// Factory for vaccination tips
  factory PetTooltip.vaccination({
    Key? key,
    required String message,
    required Widget child,
    String? title = 'Vaccination Tip',
    VoidCallback? onDismiss,
  }) {
    return PetTooltip(
      key: key,
      message: message,
      title: title,
      icon: const Icon(Icons.vaccines, color: AppTheme.petVaccinationColor),
      onDismiss: onDismiss,
      child: child,
    );
  }

  /// Factory for health tips
  factory PetTooltip.health({
    Key? key,
    required String message,
    required Widget child,
    String? title = 'Health Tip',
    VoidCallback? onDismiss,
  }) {
    return PetTooltip(
      key: key,
      message: message,
      title: title,
      icon: const Icon(Icons.favorite, color: AppTheme.petHealthyColor),
      onDismiss: onDismiss,
      child: child,
    );
  }

  /// Factory for care reminders
  factory PetTooltip.reminder({
    Key? key,
    required String message,
    required Widget child,
    String? title = 'Care Reminder',
    VoidCallback? onDismiss,
  }) {
    return PetTooltip(
      key: key,
      message: message,
      title: title,
      icon: const Icon(Icons.notification_important, color: AppTheme.petWarningColor),
      onDismiss: onDismiss,
      child: child,
    );
  }

  @override
  State<PetTooltip> createState() => _PetTooltipState();
}

class _PetTooltipState extends State<PetTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hideTooltip();
    _animationController.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (_isVisible) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlay(
        message: widget.message,
        title: widget.title,
        icon: widget.icon,
        isDismissible: widget.isDismissible,
        onDismiss: () {
          _hideTooltip();
          widget.onDismiss?.call();
        },
        targetOffset: offset,
        targetSize: size,
        placement: widget.placement,
        animation: _fadeAnimation,
      ),
    );

    overlay.insert(_overlayEntry!);
    _animationController.forward();
    _isVisible = true;
  }

  void _hideTooltip() {
    if (!_isVisible) return;

    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTooltip,
      onLongPress: _showTooltip,
      child: widget.child,
    );
  }
}

/// Tooltip overlay widget
class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.message,
    this.title,
    this.icon,
    required this.isDismissible,
    this.onDismiss,
    required this.targetOffset,
    required this.targetSize,
    required this.placement,
    required this.animation,
  });

  final String message;
  final String? title;
  final Widget? icon;
  final bool isDismissible;
  final VoidCallback? onDismiss;
  final Offset targetOffset;
  final Size targetSize;
  final TooltipPlacement placement;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Stack(
            children: [
              // Background overlay
              GestureDetector(
                onTap: onDismiss,
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              // Tooltip content
              Positioned(
                left: _calculateLeft(screenSize),
                top: _calculateTop(screenSize),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(AppTheme.radius12),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radius12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null || icon != null)
                          Row(
                            children: [
                              if (icon != null) ...[
                                icon!,
                                const SizedBox(width: AppTheme.spacing8),
                              ],
                              if (title != null)
                                Expanded(
                                  child: Text(
                                    title!,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (isDismissible)
                                GestureDetector(
                                  onTap: onDismiss,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        if (title != null || icon != null)
                          const SizedBox(height: AppTheme.spacing8),
                        Text(
                          message,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _calculateLeft(Size screenSize) {
    const padding = AppTheme.spacing16;
    const tooltipWidth = 280.0;
    
    switch (placement) {
      case TooltipPlacement.auto:
      case TooltipPlacement.top:
      case TooltipPlacement.bottom:
        final centered = targetOffset.dx + (targetSize.width / 2) - (tooltipWidth / 2);
        return centered.clamp(padding, screenSize.width - tooltipWidth - padding);
      case TooltipPlacement.left:
        return (targetOffset.dx - tooltipWidth - AppTheme.spacing8)
            .clamp(padding, screenSize.width - tooltipWidth - padding);
      case TooltipPlacement.right:
        return (targetOffset.dx + targetSize.width + AppTheme.spacing8)
            .clamp(padding, screenSize.width - tooltipWidth - padding);
    }
  }

  double _calculateTop(Size screenSize) {
    const padding = AppTheme.spacing16;
    const estimatedTooltipHeight = 100.0;
    
    switch (placement) {
      case TooltipPlacement.auto:
        final spaceBelow = screenSize.height - targetOffset.dy - targetSize.height;
        
        if (spaceBelow >= estimatedTooltipHeight + padding) {
          return targetOffset.dy + targetSize.height + AppTheme.spacing8;
        } else {
          return (targetOffset.dy - estimatedTooltipHeight - AppTheme.spacing8)
              .clamp(padding, screenSize.height - estimatedTooltipHeight - padding);
        }
      case TooltipPlacement.top:
        return (targetOffset.dy - estimatedTooltipHeight - AppTheme.spacing8)
            .clamp(padding, screenSize.height - estimatedTooltipHeight - padding);
      case TooltipPlacement.bottom:
        return targetOffset.dy + targetSize.height + AppTheme.spacing8;
      case TooltipPlacement.left:
      case TooltipPlacement.right:
        final centered = targetOffset.dy + (targetSize.height / 2) - (estimatedTooltipHeight / 2);
        return centered.clamp(padding, screenSize.height - estimatedTooltipHeight - padding);
    }
  }
}

/// Tooltip placement options
enum TooltipPlacement { auto, top, bottom, left, right }
