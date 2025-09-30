import 'package:flutter/material.dart';

class PremiumInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const PremiumInfoRow({super.key, required this.icon, required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.grey[300] : Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
