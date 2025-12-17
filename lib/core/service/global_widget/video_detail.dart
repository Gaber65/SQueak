// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

/// Stateful widget to fetch and then display video content.
class VideoStringApp extends StatefulWidget {
  const VideoStringApp({super.key, required this.video});

  final String video;

  @override
  _VideoStringAppState createState() => _VideoStringAppState();
}

class _VideoStringAppState extends State<VideoStringApp> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Validate URL first
      final videoUrl = widget.video.trim();
      if (videoUrl.isEmpty) {
        throw Exception('Video URL is empty');
      }

      debugPrint('Attempting to load video: $videoUrl');

      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: {'Accept': '*/*'},
      );

      // Add error listener
      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.hasError) {
          if (mounted) {
            setState(() {
              _errorMessage =
                  _videoPlayerController.value.errorDescription ??
                  'Unknown video error';
              _isInitializing = false;
            });
          }
        }
      });

      await _videoPlayerController.initialize();

      if (!mounted) return;

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoInitialize: true,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: ColorManager.primaryColor,
            handleColor: ColorManager.primaryColor,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.grey.shade300,
          ),
          placeholder: Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          errorBuilder: (context, message) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load video',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isInitializing = true;
                        });
                        _initializePlayer();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        _isInitializing = false;
      });
    } catch (e) {
      debugPrint('Video initialization error: $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load video: ${e.toString()}';
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Failed to load video',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isInitializing = true;
                  });
                  _initializePlayer();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isInitializing || _chewieController == null) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }
}

Future<File?> generateVideoThumbnail(String videoUrl) async {
  try {
    final dir = await getTemporaryDirectory();
    final path = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: dir.path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 400,
      quality: 75,
    );

    if (path == null) return null;
    return File(path);
  } catch (e) {
    debugPrint('Thumbnail error: $e');
    return null;
  }
}

/// Stateful widget to fetch and then display video content.
class VideoFileApp extends StatefulWidget {
  const VideoFileApp({super.key, required this.video});

  final File video;

  @override
  _VideoFileAppState createState() => _VideoFileAppState();
}

class _VideoFileAppState extends State<VideoFileApp> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Validate URL first
      final videoUrl = widget.video;
      if (videoUrl.path.isEmpty) {
        throw Exception('Video URL is empty');
      }

      debugPrint('Attempting to load video: $videoUrl');

      _videoPlayerController = VideoPlayerController.file(videoUrl);

      // Add error listener
      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.hasError) {
          if (mounted) {
            setState(() {
              _errorMessage =
                  _videoPlayerController.value.errorDescription ??
                  'Unknown video error';
              _isInitializing = false;
            });
          }
        }
      });

      await _videoPlayerController.initialize();

      if (!mounted) return;

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoInitialize: true,
          autoPlay: false,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: ColorManager.primaryColor,
            handleColor: ColorManager.primaryColor,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.grey.shade300,
          ),
          placeholder: Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          errorBuilder: (context, message) {
            return Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load video',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isInitializing = true;
                        });
                        _initializePlayer();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        _isInitializing = false;
      });
    } catch (e) {
      debugPrint('Video initialization error: $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load video: ${e.toString()}';
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Failed to load video',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isInitializing = true;
                  });
                  _initializePlayer();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isInitializing || _chewieController == null) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }
}
