// lib/features/stories/presentation/widgets/common/gradient_ring.dart
import 'package:flutter/material.dart';

class GradientRing extends StatelessWidget {
  final double size;
  final bool active;
  final Widget child;

  const GradientRing({
    super.key,
    required this.size,
    required this.active,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = active
        ? SweepGradient(
      colors: const [
        Color(0xFFFF5F6D),
        Color(0xFFFFC371),
        Color(0xFF42E695),
        Color(0xFF4776E6),
        Color(0xFFFF5F6D),
      ],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    )
        : const LinearGradient(colors: [Colors.grey, Colors.grey]);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: gradient),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: ClipOval(child: child),
        ),
      ),
    );
  }
}
// TODO: Implement gradient_ring.dart