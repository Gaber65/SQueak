// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/accessibility/accessibility_helper.dart';
import 'package:squeak/features/auth/contactus/presentation/pages/contact_us.dart';
import 'package:squeak/features/auth/shared/widgets/compact_auth_header.dart';

class EnhancedAuthHeader extends StatefulWidget {
  const EnhancedAuthHeader({
    super.key,
    required this.child,
    this.title = 'Welcome to Squeak',
    this.subtitle = 'Your Pet Care Companion',
    this.showHelpButton = true,
  });

  final Widget child;
  final String title;
  final String subtitle;
  final bool showHelpButton;

  @override
  State<EnhancedAuthHeader> createState() => _EnhancedAuthHeaderState();
}

class _EnhancedAuthHeaderState extends State<EnhancedAuthHeader>
    with SingleTickerProviderStateMixin {
  // Header visual logic is delegated to CompactAuthHeader; animations
  // previously used here have been moved/removed to avoid duplication.
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // Let the body extend behind the status bar so the gradient reaches the top
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Enhanced Header Section (more compact)
            // Include the status bar height in header so gradient fills top area
            Container(
              // Increase header visual height so it becomes more prominent
              height: 220 + MediaQuery.of(context).padding.top,
              // smaller top padding while still accounting for status bar
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top * 0.8),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorManager.primaryColor.withOpacity(0.8),
                    ColorManager.secondColor.withOpacity(0.9),
                    ColorManager.primaryColor,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  Positioned.fill(
                    child: CustomPaint(painter: PawPatternPainter()),
                  ),

                  // Help Button
                  if (widget.showHelpButton)
                    Positioned(
                      // We already padded the container by the status bar height,
                      // so position the help button from the visual top
                      top: 10,
                      left: 20,
                      child: AccessibilityHelper.semanticWrapper(
                        label: 'Help and support',
                        button: true,
                        hint: 'Get help with registration or contact support',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              navigateToScreen(context, ContactScreen());
                            },
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Main Header Content
                  Positioned.fill(
                    child: Center(
                      child: CompactAuthHeader(
                        title: widget.title,
                        subtitle: widget.subtitle,
                        logoSize: 64,
                        iconSize: 36,
                        showHelpButton: widget.showHelpButton,
                        onHelpTap: () => navigateToScreen(context, ContactScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Builder(builder: (context) {
              final media = MediaQuery.of(context);
              final headerHeight = 225.0 + media.padding.top;
              const double transformOffset = 20.0;
              final remaining = media.size.height - headerHeight;
              final minCardHeight = math.max(300.0, remaining * 0.65);

              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minCardHeight,
                ),
                child: Container(
                  transform: Matrix4.translationValues(0, -transformOffset, 0),
                  padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: widget.child,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for paw pattern background
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
