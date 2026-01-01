import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:squeak/generated/l10n.dart';

enum MediaType { image, video, audio }

class MultiMediaPreviewScreen extends StatefulWidget {
  final List<File> mediaFiles;
  final MediaType mediaType;
  final Function(List<File> files, String caption) onSend;

  static const double maxMediaSizeMB = 25.0;
  static const int maxMediaCount = 10;

  const MultiMediaPreviewScreen({
    super.key,
    required this.mediaFiles,
    this.mediaType = MediaType.image,
    required this.onSend,
  });

  @override
  State<MultiMediaPreviewScreen> createState() =>
      _MultiMediaPreviewScreenState();
}

class _MultiMediaPreviewScreenState extends State<MultiMediaPreviewScreen> {
  late List<File> _mediaFiles;
  int _currentIndex = 0;
  final TextEditingController _captionController = TextEditingController();
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  bool _isSending = false;
  bool _isAudioPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  bool get _isVideo => widget.mediaType == MediaType.video;
  bool get _isAudio => widget.mediaType == MediaType.audio;
  bool get _isImage => widget.mediaType == MediaType.image;

  double _getTotalFileSizeMB() {
    double totalSize = 0;
    for (final file in _mediaFiles) {
      try {
        totalSize += file.lengthSync() / (1024 * 1024);
      } catch (e) {
        debugPrint('Error getting file size: $e');
      }
    }
    return totalSize;
  }

  void _checkTotalFileSize() {
    final totalSizeMB = _getTotalFileSizeMB();
    if (totalSizeMB > MultiMediaPreviewScreen.maxMediaSizeMB) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSizeWarningDialog(totalSizeMB);
      });
    }
  }

  void _showSizeWarningDialog(double totalSizeMB) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'File Size Warning',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'The total size of selected media is ${totalSizeMB.toStringAsFixed(2)} MB. '
              'Please keep it under ${MultiMediaPreviewScreen.maxMediaSizeMB.toInt()} MB.',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Color(0xFF6200EA)),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _mediaFiles = List.from(widget.mediaFiles);
    _initializeCurrentMedia();
    _checkTotalFileSize();
  }

  void _initializeCurrentMedia() {
    if (_isVideo) {
      _initVideoPlayer();
    } else if (_isAudio) {
      _initAudioPlayer();
    }
  }

  Future<void> _initVideoPlayer() async {
    _videoController?.dispose();
    _videoController = VideoPlayerController.file(_mediaFiles[_currentIndex]);
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    _videoController!.play();
    setState(() {});
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer?.dispose();
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.setSourceDeviceFile(_mediaFiles[_currentIndex].path);

    _audioPlayer!.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    _audioPlayer!.onPositionChanged.listen((position) {
      setState(() {
        _audioPosition = position;
      });
    });

    _audioPlayer!.onPlayerComplete.listen((_) {
      setState(() {
        _isAudioPlaying = false;
        _audioPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _toggleVideoPlayPause() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
      });
    }
  }

  Future<void> _toggleAudioPlayPause() async {
    if (_audioPlayer != null) {
      if (_isAudioPlaying) {
        await _audioPlayer!.pause();
        setState(() {
          _isAudioPlaying = false;
        });
      } else {
        await _audioPlayer!.resume();
        setState(() {
          _isAudioPlaying = true;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _getFileName() {
    return _mediaFiles[_currentIndex].path.split('/').last;
  }

  Future<void> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _mediaFiles[_currentIndex].path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: S.of(context).editImage,
          toolbarColor: const Color(0xFF6200EA),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: S.of(context).editImage,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _mediaFiles[_currentIndex] = File(croppedFile.path);
      });
    }
  }

  Future<void> _handleSend() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    final caption = _captionController.text.trim();
    String mediaTypeName = _isVideo ? 'video' : (_isAudio ? 'audio' : 'image');
    debugPrint(
      '📸 MultiMediaPreview: Sending ${_mediaFiles.length} $mediaTypeName(s) with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
    );

    // Send the media
    widget.onSend(_mediaFiles, caption);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _handleBack,
        ),
        title: Text(
          '${S.of(context).preview} (${_currentIndex + 1}/${_mediaFiles.length})',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (_isImage)
            IconButton(
              icon: const Icon(Icons.crop_rotate, color: Colors.white),
              onPressed: _cropImage,
              tooltip: 'Crop Image',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child:
                  _isVideo
                      ? _videoController != null &&
                              _videoController!.value.isInitialized
                          ? GestureDetector(
                            onTap: _toggleVideoPlayPause,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                ),
                                if (!_videoController!.value.isPlaying)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                              ],
                            ),
                          )
                          : const CircularProgressIndicator()
                      : _isAudio
                      ? Container(
                        margin: const EdgeInsets.all(40),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF9800),
                                    Color(0xFFFF6F00),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF9800,
                                    ).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.audiotrack,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              S.of(context).audioFile,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getFileName(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 32),
                            // Audio progress slider
                            if (_audioDuration.inSeconds > 0)
                              Column(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 4.0,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6.0,
                                      ),
                                    ),
                                    child: Slider(
                                      value:
                                          _audioPosition.inSeconds.toDouble(),
                                      max: _audioDuration.inSeconds.toDouble(),
                                      onChanged: (value) async {
                                        await _audioPlayer?.seek(
                                          Duration(seconds: value.toInt()),
                                        );
                                      },
                                      activeColor: const Color(0xFFFF9800),
                                      inactiveColor: Colors.grey[700],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDuration(_audioPosition),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(_audioDuration),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 16),
                            // Play/Pause button
                            GestureDetector(
                              onTap: _toggleAudioPlayPause,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF9800),
                                      Color(0xFFFF6F00),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF9800,
                                      ).withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isAudioPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.file(
                          _mediaFiles[_currentIndex],
                          fit: BoxFit.contain,
                        ),
                      ),
            ),
          ),
          // Thumbnail strip for multi-file preview
          if (_mediaFiles.length > 1)
            Container(
              height: 80,
              color: const Color(0xFF1E1E1E),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _mediaFiles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                        _isAudioPlaying = false;
                        _audioPosition = Duration.zero;
                      });
                      _initializeCurrentMedia();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              _currentIndex == index
                                  ? const Color(0xFF6200EA)
                                  : Colors.transparent,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child:
                            _isAudio
                                ? Container(
                                  width: 64,
                                  color: const Color(0xFF2E2E2E),
                                  child: const Center(
                                    child: Icon(
                                      Icons.audiotrack,
                                      color: Color(0xFFFF9800),
                                      size: 32,
                                    ),
                                  ),
                                )
                                : _isVideo
                                ? VideoThumbnail(_mediaFiles[index])
                                : Image.file(
                                  _mediaFiles[index],
                                  fit: BoxFit.cover,
                                  width: 64,
                                  height: 64,
                                ),
                      ),
                    ),
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2E2E2E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _captionController,
                      enabled: !_isSending,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: S.of(context).addCaption,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6200EA), Color(0xFF9C27B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6200EA).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon:
                          _isSending
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                              : const Icon(Icons.send, color: Colors.white),
                      onPressed: _isSending ? null : _handleSend,
                      tooltip: S.of(context).send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper widget to display video thumbnail
class VideoThumbnail extends StatefulWidget {
  final File videoFile;

  const VideoThumbnail(this.videoFile, {super.key});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.file(widget.videoFile);
    await _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(
        color: const Color(0xFF2E2E2E),
        child: const Center(
          child: Icon(Icons.videocam, color: Color(0xFF00BCD4), size: 24),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
        const Icon(Icons.play_circle_filled, color: Colors.white70, size: 24),
      ],
    );
  }
}
