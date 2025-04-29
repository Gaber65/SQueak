import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class YoutubeCardWidget extends StatelessWidget {
  const YoutubeCardWidget({
    super.key,
    required this.videoImage,
    required this.videoUrl,
  });

  final String videoImage;
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToReference(url: videoUrl);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(videoImage, fit: BoxFit.fill),
                  ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Image.asset('assets/youtube_logo.png'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
