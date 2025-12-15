import 'package:flutter/material.dart';

class RecordingOverlay extends StatelessWidget {
  final int recordDuration;
  final int maxRecordDuration;

  const RecordingOverlay({
    super.key,
    required this.recordDuration,
    this.maxRecordDuration = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final minutes = (recordDuration ~/ 60).toString().padLeft(2, '0');
    final seconds = (recordDuration % 60).toString().padLeft(2, '0');
    final isNearLimit = recordDuration >= maxRecordDuration - 10;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isNearLimit ? Colors.orange : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$minutes:$seconds',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    isNearLimit
                        ? Colors.orange
                        : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: List.generate(
                  20,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      width: 3,
                      height: 12 + (index % 3) * 8,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
