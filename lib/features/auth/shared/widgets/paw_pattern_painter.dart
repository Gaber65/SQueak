import 'dart:math' as math;
import 'package:flutter/material.dart';

class PawPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    // Draw scattered paw prints
    for (int i = 0; i < 15; i++) {
      final x = (i * 0.15 * size.width + 50) % size.width;
      final y = (i * 0.25 * size.height + 30) % size.height;

      _drawPawPrint(canvas, paint, Offset(x, y), 0.8);
    }
  }

  void _drawPawPrint(Canvas canvas, Paint paint, Offset center, double scale) {
    final pawSize = 16.0 * scale;

    // Main pad
    canvas.drawOval(
      Rect.fromCenter(center: center, width: pawSize, height: pawSize * 0.8),
      paint,
    );

    // Toe pads
    final toeSize = pawSize * 0.3;
    for (int i = 0; i < 4; i++) {
      final angle = (i * 45 - 67.5) * (3.14159 / 180);
      final toeCenter = Offset(
        center.dx + (pawSize * 0.6) * math.cos(angle),
        center.dy + (pawSize * 0.6) * math.sin(angle) - pawSize * 0.2,
      );

      canvas.drawOval(
        Rect.fromCenter(center: toeCenter, width: toeSize, height: toeSize),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
