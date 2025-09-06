import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/accessibility/accessibility_helper.dart';
import 'package:squeak/features/auth/contactus/presentation/pages/contact_us.dart';

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
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Enhanced Header Section
            Container(
              height: 300,
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
                    child: CustomPaint(
                      painter: PawPatternPainter(),
                    ),
                  ),
                  
                  // Help Button
                  if (widget.showHelpButton)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
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
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo Container
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset(
                                        'assets/squeaklogo.PNG',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.pets,
                                            size: 60,
                                            color: ColorManager.primaryColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Title
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Subtitle
                                Text(
                                  widget.subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Section
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
              padding: const EdgeInsets.only(top: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: widget.child,
            ),
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
    final paint = Paint()
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
      Rect.fromCenter(
        center: center,
        width: pawSize,
        height: pawSize * 0.8,
      ),
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
        Rect.fromCenter(
          center: toeCenter,
          width: toeSize,
          height: toeSize,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
