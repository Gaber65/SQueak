import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhotosTab extends StatelessWidget {
  final bool isDarkMode;

  const PhotosTab({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [
                  Colors.grey.shade700,
                  Colors.grey.shade800,
                ]
                    : [
                  Colors.grey.shade100,
                  Colors.grey.shade200,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.grey.shade600
                    : Colors.grey.shade300,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => HapticFeedback.lightImpact(),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_rounded,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Photo ${index + 1}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}