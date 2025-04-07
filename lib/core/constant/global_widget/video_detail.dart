import 'package:flutter/material.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

/// Stateful widget to fetch and then display video content.
class VideoStringApp extends StatefulWidget {
  VideoStringApp({super.key, required this.video});

  final String video;

  @override
  _VideoStringAppState createState() => _VideoStringAppState();
}

class _VideoStringAppState extends State<VideoStringApp> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
      widget.video,
    )..addListener(() => setState(() {}));
    videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: false,
      autoPlay: false,
      materialProgressColors:
          ChewieProgressColors(playedColor: ColorTheme.primaryColor),
      errorBuilder: (context, message) {
        return Center(
          child: Text(message),
        );
      },
    );
  }

  @override
  void dispose() {
    chewieController.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: (videoPlayerController == null)
          ? Container(
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
            )
          : videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: videoPlayerController.value.size.width /
                      videoPlayerController.value.size.height,
                  child: Container(
                    color: Colors.black,
                    child: Chewie(
                      controller: chewieController,
                    ),
                  ),
                )
              : const SizedBox(
                  height: 150,
                  child: Center(child: Text('Video Loading...')),
                ),
    );
  }
}
