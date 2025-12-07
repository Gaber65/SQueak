import 'package:flutter/material.dart';

/// Reusable dialog action buttons (Cancel & Confirm)
class DialogActionButtons extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback? onConfirm;
  final Color confirmColor;
  final bool isConfirmEnabled;

  const DialogActionButtons({
    super.key,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    this.onConfirm,
    this.confirmColor = Colors.blue,
    this.isConfirmEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 20,
              ),
            ),
            child: Text(
              cancelText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: isConfirmEnabled ? onConfirm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isConfirmEnabled ? confirmColor : Colors.grey[300],
              foregroundColor: isConfirmEnabled ? Colors.white : Colors.grey[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 20,
              ),
              elevation: isConfirmEnabled ? 2 : 0,
            ),
            child: Text(
              confirmText,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
