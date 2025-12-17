// action_button.dart
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isSmall;
  final String? label;

  const ActionButton._({
    required this.icon,
    required this.color,
    this.onTap,
    this.isSmall = true,
    this.label,
  });

  /// small circular button
  factory ActionButton.small({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return ActionButton._(
      icon: icon,
      color: color,
      onTap: onTap,
      isSmall: true,
    );
  }

  /// larger button with optional label
  factory ActionButton.large({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    String? label,
  }) {
    return ActionButton._(
      icon: icon,
      color: color,
      onTap: onTap,
      isSmall: false,
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSmall) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            if (label != null) ...[
              const SizedBox(width: 6),
              Text(
                label!,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
