// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';

import '../global_function/format_utils.dart';

class ImageDetailSimple extends StatelessWidget {
  final String path;
  final String title;
  final String description;

  const ImageDetailSimple({
    super.key,
    required this.path,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black, 
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.75,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                minScale: 0.8,
                maxScale: 4.0,
                child: Hero(
                  tag: path,
                  child: Image.network(
                    path,
                    width: double.infinity,
                    fit: BoxFit.contain, 
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              isArabic() ? 'اغلاق' : 'Close',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
