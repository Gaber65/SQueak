import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/generated/l10n.dart';

class LoadingStateWidget extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final S s;

  const LoadingStateWidget({
    super.key,
    required this.theme,
    required this.isDark,
    required this.s,
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
              'https://lottie.host/71b548e6-5cb4-4edb-ad43-cee69b516f49/0BKYpwc1Vc.json',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 24),
            _buildGlassCard(
              theme,
              isDark,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  s.fetchingPetChats,
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

