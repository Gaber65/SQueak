import 'package:flutter/material.dart';

/// Reusable dialog header with icon and title
class DialogHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onClose;

  const DialogHeader({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (onClose != null)
          IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
      ],
    );
  }
}
