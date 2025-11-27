import 'package:chewie/chewie.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/generated/l10n.dart';
import 'package:video_player/video_player.dart';

enum MediaType { image, video }

class FullScreenMediaViewer extends StatefulWidget {
  final String mediaUrl;
  final MediaType mediaType;

  const FullScreenMediaViewer({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
  });

  @override
  State<FullScreenMediaViewer> createState() => _FullScreenMediaViewerState();
}

class _FullScreenMediaViewerState extends State<FullScreenMediaViewer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitializing = true;
  String? _errorMessage;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl),
      );

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error playing video',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );

      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isInitializing = false;
      });
      debugPrint('❌ Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media content
          Center(
            child:
                widget.mediaType == MediaType.image
                    ? _buildImageViewer()
                    : _buildVideoViewer(),
          ),

          // Close button and menu for video
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // More options menu (only for video)
                    if (widget.mediaType == MediaType.video)
                      Material(
                        color: Colors.black.withOpacity(0.5),
                        shape: const CircleBorder(),
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 24,
                          ),
                          color: Colors.grey[900],
                          onSelected: (value) {
                            _handleMenuAction(value);
                          },
                          itemBuilder:
                              (context) => [
                                PopupMenuItem(
                                  value: 'speed',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.speed,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${S.of(context).playbackSpeed} (${_playbackSpeed}x)',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'quality',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.high_quality,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        S.of(context).quality,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'download',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.download,
                                        color: Colors.white70,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        S.of(context).download,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                        ),
                      ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.black.withOpacity(0.5),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: FastCachedImage(
        url: widget.mediaUrl,
        fit: BoxFit.contain,
        loadingBuilder:
            (context, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progressPercentage.value / 100,
                color: Colors.white,
              ),
            ),
        errorBuilder:
            (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white70,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).imageloadingFailed,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildVideoViewer() {
    if (_isInitializing) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white70, size: 64),
              const SizedBox(height: 16),
              Text(
                S.of(context).videoLoadingFailed,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Chewie(controller: _chewieController!);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'speed':
        _showSpeedDialog();
        break;
      case 'quality':
        _showQualityDialog();
        break;
      case 'download':
        _downloadVideo();
        break;
    }
  }

  void _showSpeedDialog() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
            title: Text(
              S.of(context).playbackSpeed,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0].map((speed) {
                    return RadioListTile<double>(
                      title: Text(
                        '${speed}x',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      value: speed,
                      groupValue: _playbackSpeed,
                      activeColor: isDarkMode ? Colors.blueAccent : Colors.blue,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _playbackSpeed = value;
                            _videoController?.setPlaybackSpeed(value);
                          });
                          Navigator.pop(context);
                        }
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showQualityDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            title: Text(
              S.of(context).videoQuality,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            content: Text(
              S.of(context).qualitySource,
              style: TextStyle(color: isDark ? Colors.white : Colors.black54),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  S.of(context).ok,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
    );
  }

  void _downloadVideo() {}
}
