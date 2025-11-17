import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CareLoadingWidget extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final String text;

  const CareLoadingWidget({
    super.key,
    required this.theme,
    required this.isDark,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.network(
              'https://lottie.host/6e6d8757-9768-47df-95f6-8551fae94403/0K1G01cW6d.json',
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 24),
            _buildGlassCard(
              '',
              theme,
              isDark,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
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

Widget _buildGlassCard(
  String text,
  ThemeData theme,
  bool isDark, {
  required Widget child,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isDark
                    ? [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ]
                    : [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: child,
      ),
    ),
  );
}
