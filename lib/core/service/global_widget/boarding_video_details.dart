// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../global_function/format_utils.dart';

class VideoDetailSimple extends StatefulWidget {
  final String path;
  final String title;
  final String description;
  final bool autoPlay;
  final bool isAsset;

  const VideoDetailSimple({
    super.key,
    required this.path,
    required this.title,
    required this.description,
    this.autoPlay = false,
    this.isAsset = true,
  });

  @override
  State<VideoDetailSimple> createState() => _VideoDetailSimpleState();
}

class _VideoDetailSimpleState extends State<VideoDetailSimple>
    with WidgetsBindingObserver {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _isPlaying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) _pauseVideo();
  }

  String _getCorrectAssetPath(String path) {
    if (path.startsWith('flutter_assets/')) {
      path = path.replaceFirst('flutter_assets/', '');
    }
    if (!path.startsWith('assets/')) {
      if (path.startsWith('/')) path = path.substring(1);
      path = 'assets/$path';
    }
    return path;
  }

  void _initializeVideo() {
    try {
      if (widget.path.startsWith('http://') ||
          widget.path.startsWith('https://')) {
        _videoController = VideoPlayerController.network(widget.path);
      } else if (widget.isAsset) {
        _videoController = VideoPlayerController.asset(
          _getCorrectAssetPath(widget.path),
        );
      } else {
        _videoController = VideoPlayerController.file(File(widget.path));
      }

      _videoController
          .initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _chewieController = ChewieController(
                  videoPlayerController: _videoController,
                  autoPlay: widget.autoPlay,
                  looping: true,
                  allowFullScreen: true,
                  showOptions: true,
                  allowMuting: true,
                  showControlsOnInitialize: true,
                  aspectRatio: _videoController.value.aspectRatio,
                );
                _isLoading = false;
                _isPlaying = widget.autoPlay;
              });
              _videoController.addListener(_videoListener);
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                _error =
                    isArabic()
                        ? 'خطأ في تحميل الفيديو:\n$error'
                        : 'Error loading video:\n$error';
                _isLoading = false;
              });
            }
          });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              isArabic()
                  ? 'خطأ في تهيئة الفيديو:\n$e'
                  : 'Error initializing video:\n$e';
          _isLoading = false;
        });
      }
    }
  }

  void _videoListener() {
    if (mounted && _videoController.value.isInitialized) {
      final isPlaying = _videoController.value.isPlaying;
      if (_isPlaying != isPlaying) {
        setState(() => _isPlaying = isPlaying);
      }
    }
  }

  void _pauseVideo() {
    if (_videoController.value.isInitialized &&
        _videoController.value.isPlaying) {
      _videoController.pause();
      setState(() => _isPlaying = false);
    }
  }

  void _playVideo() {
    if (_videoController.value.isInitialized &&
        !_videoController.value.isPlaying) {
      _videoController.play();
      setState(() => _isPlaying = true);
    }
  }

  void _togglePlayback() => _isPlaying ? _pauseVideo() : _playVideo();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_videoController.value.isInitialized) {
      _videoController.pause();
      _videoController.removeListener(_videoListener);
    }
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            _pauseVideo();
            Navigator.pop(context);
          },
        ),
        actions: [
          if (!_isLoading && _error == null)
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: _togglePlayback,
            ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          _pauseVideo();
          return true;
        },
        child:
            _isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        isArabic()
                            ? 'جاري تحميل الفيديو...'
                            : 'Loading video...',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                )
                : _error != null
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: Chewie(controller: _chewieController!),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      if (widget.description.isNotEmpty)
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_videoController.value.isInitialized)
                            Row(
                              children: [
                                const Icon(
                                  Icons.videocam,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${_videoController.value.duration.inMinutes}:${(_videoController.value.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _pauseVideo();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: Text(isArabic() ? 'إغلاق' : 'Close'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
