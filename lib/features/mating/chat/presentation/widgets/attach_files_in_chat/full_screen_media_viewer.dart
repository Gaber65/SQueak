import 'package:chewie/chewie.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squeak/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'in_app_document_viewer.dart';

enum MediaType { image, video, document }

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
    } else if (widget.mediaType == MediaType.document) {
      // Optionally, auto-download or open document
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
                    : widget.mediaType == MediaType.video
                    ? _buildVideoViewer()
                    : _buildDocumentViewer(),
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
                    // More options menu (for video and document)
                    if (widget.mediaType == MediaType.video ||
                        widget.mediaType == MediaType.document)
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
                                if (widget.mediaType == MediaType.video)
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
                                if (widget.mediaType == MediaType.video)
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
                                if (widget.mediaType == MediaType.document)
                                  PopupMenuItem(
                                    value: 'open_external',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.open_in_new,
                                          color: Colors.white70,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          S.of(context).openInBrowser,
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
      case 'open_external':
        _openDocumentInBrowser();
        break;
      case 'download':
        _downloadMedia();
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

  void _downloadMedia() {

  }

  void _openInApp() {
    final fileName = widget.mediaUrl.split('/').last.split('?').first;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => InAppDocumentViewer(
              documentUrl: widget.mediaUrl,
              fileName: fileName,
            ),
      ),
    );
  }

  Future<void> _openDocumentInBrowser() async {
    try {
      final uri = Uri.parse(widget.mediaUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).cannotOpenDocument),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error opening document: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.of(context).error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDocumentViewer() {
    final fileName = widget.mediaUrl.split('/').last.split('?').first;
    final extension = fileName.split('.').last.toUpperCase();

    IconData icon;
    Color iconColor;

    switch (extension) {
      case 'PDF':
        icon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'DOC':
      case 'DOCX':
        icon = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'XLS':
      case 'XLSX':
        icon = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'PPT':
      case 'PPTX':
        icon = Icons.slideshow;
        iconColor = Colors.orange;
        break;
      case 'TXT':
        icon = Icons.text_snippet;
        iconColor = Colors.grey;
        break;
      case 'ZIP':
      case 'RAR':
      case '7Z':
        icon = Icons.folder_zip;
        iconColor = Colors.amber;
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = Colors.blueGrey;
    }

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 120, color: iconColor),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              extension,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            fileName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            onPressed: _openInApp,
            icon: const Icon(Icons.article_outlined),
            label: Text(S.of(context).openInApp),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: iconColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _openDocumentInBrowser,
            icon: const Icon(Icons.open_in_new),
            label: Text(S.of(context).openInBrowser),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _downloadMedia,
            icon: const Icon(Icons.download_rounded),
            label: Text(S.of(context).download),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
