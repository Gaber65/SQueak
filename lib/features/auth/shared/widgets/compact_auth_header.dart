import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/accessibility/accessibility_helper.dart';
import 'package:squeak/features/auth/shared/widgets/paw_pattern_painter.dart';

class CompactAuthHeader extends StatelessWidget {
  const CompactAuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoSize = 64.0,
    this.iconSize = 36.0,
    this.showHelpButton = true,
    this.onHelpTap,
  });

  final String title;
  final String subtitle;
  final double logoSize;
  final double iconSize;
  final bool showHelpButton;
  final VoidCallback? onHelpTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(child: CustomPaint(painter: PawPatternPainter())),
        ),
        if (showHelpButton)
          Positioned(
            top: 10,
            left: 20,
            child: AccessibilityHelper.semanticWrapper(
              label: 'Help and support',
              button: true,
              hint: 'Get help with registration or contact support',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onHelpTap,
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
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all((logoSize - iconSize) / 2),
                    child: Icon(
                      Icons.pets,
                      size: iconSize,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 0.5),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
