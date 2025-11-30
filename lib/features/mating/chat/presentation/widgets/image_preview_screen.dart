import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:squeak/generated/l10n.dart';

enum MediaType { image, video, audio }

class MediaPreviewScreen extends StatefulWidget {
  final File mediaFile;
  final MediaType mediaType;
  final bool? cameraOption;
  final Function(File file, String caption) onSend;

  const MediaPreviewScreen({
    super.key,
    required this.mediaFile,
    this.mediaType = MediaType.image,
    required this.onSend,
    this.cameraOption,
  });

  factory MediaPreviewScreen.legacy({
    required File mediaFile,
    bool isVideo = false,
    required Function(File file, String caption) onSend,
  }) {
    return MediaPreviewScreen(
      mediaFile: mediaFile,
      mediaType: isVideo ? MediaType.video : MediaType.image,
      onSend: onSend,
    );
  }

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class ImagePreviewScreen extends MediaPreviewScreen {
  const ImagePreviewScreen({
    super.key,
    required File imageFile,
    required super.onSend,
  }) : super(mediaFile: imageFile, mediaType: MediaType.image);
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  late File _currentMedia;
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

  @override
  void initState() {
    super.initState();
    _currentMedia = widget.mediaFile;
    if (_isVideo) {
      _initVideoPlayer();
    } else if (_isAudio) {
      _initAudioPlayer();
    }
  }

  Future<void> _initVideoPlayer() async {
    _videoController = VideoPlayerController.file(_currentMedia);
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    _videoController!.play();
    setState(() {});
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.setSourceDeviceFile(_currentMedia.path);

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
    return _currentMedia.path.split('/').last;
  }

  Future<void> _cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _currentMedia.path,
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
        _currentMedia = File(croppedFile.path);
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
      '📸 MediaPreview: Sending $mediaTypeName with caption: "${caption.isEmpty ? '(no caption)' : caption}"',
    );

    // Send the media
    widget.onSend(_currentMedia, caption);
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
          icon: Icon(
            widget.cameraOption == true ? Icons.close : Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: _handleBack,
        ),
        title:  Text(S.of(context).preview, style: TextStyle(color: Colors.white)),
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
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      size: 64,
                                      color: Colors.white,
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
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF9800,
                                    ).withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.audiotrack_rounded,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                             Text(
                              S.of(context).audioFile,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getFileName(),
                              style: TextStyle(
                                color: Colors.grey[400],
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
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6,
                                      ),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                            overlayRadius: 14,
                                          ),
                                    ),
                                    child: Slider(
                                      value:
                                          _audioPosition.inSeconds.toDouble(),
                                      max: _audioDuration.inSeconds.toDouble(),
                                      activeColor: const Color(0xFFFF9800),
                                      inactiveColor: Colors.grey[700],
                                      onChanged: (value) async {
                                        final position = Duration(
                                          seconds: value.toInt(),
                                        );
                                        await _audioPlayer?.seek(position);
                                      },
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
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(_audioDuration),
                                          style: TextStyle(
                                            color: Colors.grey[400],
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
                                padding: const EdgeInsets.all(16),
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
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.file(_currentMedia, fit: BoxFit.contain),
                      ),
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
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
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
