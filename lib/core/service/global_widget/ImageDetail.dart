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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const _CustomAppBar(),
      body: const _ImageDetailBody(),
    );
  }
}
class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'Image Viewer',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
class _ImageDetailBody extends StatelessWidget {
  const _ImageDetailBody();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as ImageDetailSimple?;

    if (args == null) {
      return const Center(child: Text('No image data', style: TextStyle(color: Colors.white)));
    }

    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              minScale: 0.8,
              maxScale: 4.0,
              child: Hero(
                tag: args.path,
                child: Image.network(
                  args.path,
                  width: size.width,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54, size: 60),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: _DescriptionCard(
              title: args.title,
              description: args.description,
            ),
          ),
        ),
      ],
    );
  }
}
class _DescriptionCard extends StatelessWidget {
  final String title;
  final String description;

  const _DescriptionCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
    );
  }
}
