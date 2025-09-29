import 'package:flutter/material.dart';

class PremiumIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isDark;

  const PremiumIconButton({super.key, required this.icon, required this.color, required this.onPressed, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.1) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Icon(icon, size: 20, color: isDark ? color.withOpacity(0.3) : color),
      ),
    );
  }
}
