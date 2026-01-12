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
  final List<String>? mediaUrls; // Support multiple images/videos
  final MediaType mediaType;
  final String? caption;
  final List<String?>? captions;
  final List<MediaType>? mediaTypes; // Support mixed media types
  final int initialIndex; // Index of the selected media

  const FullScreenMediaViewer({
    super.key,
    required this.mediaUrl,
    this.mediaUrls,
    required this.mediaType,
    this.caption,
    this.captions,
    this.mediaTypes,
    this.initialIndex = 0,
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
  
  // For image gallery support
  late List<String> _mediaUrls;
  late List<String?> _captions;
  late List<MediaType> _mediaTypes;
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    
    // Initialize media URLs list
    if (widget.mediaUrls != null && widget.mediaUrls!.isNotEmpty) {
      _mediaUrls = widget.mediaUrls!;
      _captions = widget.captions ?? List.filled(_mediaUrls.length, null);
      _mediaTypes = widget.mediaTypes ?? List.filled(_mediaUrls.length, widget.mediaType);
      // Set current index from initialIndex parameter
      _currentIndex = widget.initialIndex.clamp(0, _mediaUrls.length - 1);
    } else {
      _mediaUrls = [widget.mediaUrl];
      _captions = [widget.caption];
      _mediaTypes = [widget.mediaType];
      _currentIndex = 0;
    }
    
    _pageController = PageController(initialPage: _currentIndex);
    
    _initializeCurrentMedia();
  }

  void _initializeCurrentMedia() {
    if (_mediaTypes[_currentIndex] == MediaType.video) {
      _initializeVideo(_mediaUrls[_currentIndex]);
    } else {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _initializeVideo(String videoUrl) async {
    try {
      // Only initialize if still mounted and this is the current video
      if (!mounted) return;
      
      _videoController?.dispose();
      _chewieController?.dispose();
      
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      await _videoController!.initialize();

      // Check again after async operation
      if (!mounted) return;

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

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      
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
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCurrentMedia() {
    if (_mediaTypes[_currentIndex] == MediaType.image) {
      return _buildImageGallery();
    } else if (_mediaTypes[_currentIndex] == MediaType.video) {
      return _buildVideoViewer();
    } else {
      return _buildDocumentViewer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Media content
          Center(
            child: _buildCurrentMedia(),
          ),

          // Caption at bottom (for image/video)
          if (_captions[_currentIndex] != null && _captions[_currentIndex]!.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                child: Text(
                  _captions[_currentIndex]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          // Close button and menu for video / Image counter for multiple images
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image counter (for multiple media)
                    if (_mediaUrls.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentIndex + 1}/${_mediaUrls.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
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

  Widget _buildImageGallery() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
          _errorMessage = null; // Clear previous errors
        });
        
        // Dispose video controller when navigating away from a video
        if (_mediaTypes[_currentIndex] == MediaType.image) {
          _videoController?.dispose();
          _chewieController?.dispose();
          _videoController = null;
          _chewieController = null;
        }
        
        // Initialize video if the new page is a video
        if (_mediaTypes[index] == MediaType.video) {
          _initializeCurrentMedia();
        }
      },
      itemCount: _mediaUrls.length,
      itemBuilder: (context, index) {
        if (_mediaTypes[index] == MediaType.video) {
          return _buildVideoViewer();
        } else {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: FastCachedImage(
              url: _mediaUrls[index],
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
      },
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

  void _downloadMedia() {}

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
