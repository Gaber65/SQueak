import 'package:flutter/material.dart';

import '../../../../core/service/global_function/format_utils.dart';

class QrGuidelineDialog extends StatelessWidget {
  final String message;

  const QrGuidelineDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.qr_code, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            isArabic()
                ? 'رمز الاستجابة السريعة جاهز للاستخدام!'
                : 'QR Code Ready to Use!',
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic() ? 'إليك كيفية استخدامه:' : 'Here\'s how you can use it:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildStep(
            isArabic()
                ? '1. اذهب إلى قسم "حيواناتي الأليفة"'
                : '1. Go to "My Pets" section',
          ),
          _buildStep(
            isArabic()
                ? '2. اختر الحيوان الأليف الذي تريد ربطه'
                : '2. Select a pet you want to link',
          ),
          _buildStep(
            isArabic()
                ? '3. اضغط على "ربط QR" وامسح هذا الرمز'
                : '3. Tap "Link QR" and scan this code',
          ),
          _buildStep(
            isArabic()
                ? '4. قم بتنزيل وطباعة رمز الاستجابة السريعة'
                : '4. Download and print the QR code',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(isArabic() ? 'فهمت!' : 'Got it!'),
        ),
      ],
    );
  }

  Widget _buildStep(String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(step, style: const TextStyle(fontSize: 14)),
    );
  }
}
