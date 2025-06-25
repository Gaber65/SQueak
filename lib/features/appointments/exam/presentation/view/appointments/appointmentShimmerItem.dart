import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget appointmentShimmerItem(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Status & Time Row
            Row(
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 100, height: 10, color: Colors.white),
                const Spacer(),
                Container(width: 60, height: 10, color: Colors.white),
                const SizedBox(width: 10),
                // Fake options icon
                Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ],
            ),

            const SizedBox(height: 15),

            // Pet & Clinic Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fake pet/clinic image
                const CircleAvatar(radius: 30, backgroundColor: Colors.white),
                const SizedBox(width: 20),

                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 140, height: 10, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 10, color: Colors.white),
                    ],
                  ),
                ),

                // Fake location icon
                const SizedBox(width: 10),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Buttons row
            Row(
              children: [
                Expanded(child: Container(height: 35, decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8.0))))),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 35, decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8.0))))),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 35, decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(8.0))))),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
