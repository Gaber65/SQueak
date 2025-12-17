import 'package:flutter/material.dart';

/// Reusable icon container with circular background
class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final double padding;

  const IconContainer({
    super.key,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.size = 40,
    this.iconSize = 20,
    this.padding = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? iconColor.withOpacity(0.1),
      ),
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}
