import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../network/end_points.dart';

class GlobalImage extends StatelessWidget {

  const GlobalImage({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FastCachedImage(
          url: imageUrl + imagePath,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      ),
    );
  }
}
