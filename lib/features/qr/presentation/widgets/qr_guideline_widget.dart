import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_utils.dart';

class QrGuidelineWidget extends StatelessWidget {
  const QrGuidelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.qr_code,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: responsiveWidth(8, context)),
          const Text('QR Code Ready to Use!'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This QR code isn\'t linked to any pet yet. Here\'s how you can use it:',
            style: TextStyle(
              fontSize: responsiveFontSize(14, context),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          SizedBox(height: responsiveHeight(16, context)),
          _buildStep('1. Go to "My Pets" section'),
          _buildStep('2. Select a pet you want to link'),
          _buildStep('3. Tap "Link QR" and scan this code'),
          _buildStep('4. Download and print the QR code'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it!'),
        ),
      ],
    );
  }

  Widget _buildStep(String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        step,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
