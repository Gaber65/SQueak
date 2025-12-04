import 'package:flutter/material.dart';

import '../../../../../../core/service/global_widget/video_detail.dart';

class VideoFullScreenPlayer extends StatelessWidget {
  final String videoUrl;
  final String title;

  const VideoFullScreenPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: VideoStringApp(video: videoUrl)),
    );
  }
}