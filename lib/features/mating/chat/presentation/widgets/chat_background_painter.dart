import 'package:flutter/material.dart';

class ChatBackgroundPainter extends CustomPainter {
  final Color color;

  ChatBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    const spacing = 30.0;
    const iconSize = 20.0;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        _drawPawPrint(canvas, paint, x, y, iconSize);
      }
    }
  }

  void _drawPawPrint(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double size,
  ) {
    canvas.drawCircle(Offset(x, y + size * 0.3), size * 0.2, paint);
    canvas.drawCircle(Offset(x, y), size * 0.12, paint);
    canvas.drawCircle(
      Offset(x - size * 0.22, y + size * 0.12),
      size * 0.12,
      paint,
    );
    canvas.drawCircle(
      Offset(x + size * 0.22, y + size * 0.12),
      size * 0.12,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
