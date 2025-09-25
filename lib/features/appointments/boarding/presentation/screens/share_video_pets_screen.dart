// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../../../../core/service/global_widget/boarding_video_details.dart';
import '../../domain/entities/boarding_entry_entity.dart';

/// Enhanced Video Carousel Widget with dark mode support and smooth animations
/// Displays boarding videos in a carousel format with navigation, sharing, and full-screen options
class VideoCarouselWidget extends StatefulWidget {
  final bool open; // Controls whether the carousel dialog is visible
  final void Function(bool) onOpenChange; // Callback when open state changes
  final BoardingEntryEntity? boarding; // Boarding entity containing video data
  final void Function(String videoUrl, String platform)
  onShare; // Share callback
  final bool isDarkMode; // Theme mode toggle

  const VideoCarouselWidget({
    super.key,
    required this.open,
    required this.onOpenChange,
    required this.boarding,
    required this.onShare,
    required this.isDarkMode,
  });

  @override
  State<VideoCarouselWidget> createState() => _VideoCarouselWidgetState();
}

class _VideoCarouselWidgetState extends State<VideoCarouselWidget>
    with TickerProviderStateMixin {
  // Controllers and state management
  late PageController
  _pageController; // Controls the PageView for video carousel
  int currentVideoIndex = 0; // Currently displayed video index
  bool isVideoLoading = true; // Loading state for videos

  // Animation controllers for smooth transitions
  late AnimationController _animationController; // Main dialog animation
  late AnimationController _fadeController; // Fade in/out animation
  late AnimationController _pulseController; // Pulse animation for loading
  late Animation<double> _scaleAnimation; // Scale animation for dialog
  late Animation<double> _fadeAnimation; // Fade animation

  // Video player controllers - one for each video to manage playback
  List<VideoPlayerController?> _videoControllers = [];
  List<bool> _videoInitialized = []; // Track which videos are initialized
  List<bool> _isPlaying = []; // Track playing state for each video

  // Dark mode color scheme - computed properties for consistent theming
  Color get _textPrimaryColor =>
      widget.isDarkMode ? Colors.white : Colors.black87;

  Color get _textSecondaryColor =>
      widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

  Color get _overlayColor =>
      widget.isDarkMode
          ? Colors.black.withOpacity(0.7)
          : Colors.black.withOpacity(0.5);

  Color get _shimmerBaseColor =>
      widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

  Color get _shimmerHighlightColor =>
      widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupAnimations();
    _initializeVideoControllers();
  }

  /// Sets up all animation controllers used in the widget
  void _setupAnimations() {
    // Main dialog scale animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Fade transition animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Pulse animation for loading states
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Scale animation with elastic curve for appealing entrance
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Smooth fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Start animations if dialog should be open
    if (widget.open) {
      _animationController.forward();
      _fadeController.forward();
    }
  }

  /// Initializes video controllers for all boarding videos
  void _initializeVideoControllers() {
    if (widget.boarding?.boardingImages != null) {
      final videoCount = widget.boarding!.boardingImages.length;

      // Initialize lists to track video states
      _videoControllers = List.filled(videoCount, null);
      _videoInitialized = List.filled(videoCount, false);
      _isPlaying = List.filled(videoCount, false);

      // Create video controller for the first video (lazy loading for others)
      if (videoCount > 0) {
        _initializeVideoController(0);
      }
    }
  }

  /// Initializes a specific video controller by index
void _initializeVideoController(int index) {
  if (widget.boarding?.boardingImages != null &&
      index < widget.boarding!.boardingImages.length &&
      _videoControllers[index] == null) {
    final videoName = widget.boarding?.boardingImages[index]?['VideoName'];
    if (videoName != null && videoName.isNotEmpty) {
      final videoUrl = imageUrlWithVetICare + videoName;
      
      _videoControllers[index] = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _videoInitialized[index] = true;
              isVideoLoading = false;
            });
          }
        }).catchError((error) {
          print('Video initialization error for index $index: $error');
          if (mounted) {
            setState(() {
              _videoInitialized[index] = false;
              isVideoLoading = false;
            });
          }
        });

      // 添加循环播放监听
      _videoControllers[index]!.addListener(() {
        if (_videoControllers[index]!.value.position == 
            _videoControllers[index]!.value.duration) {
          _videoControllers[index]!.seekTo(Duration.zero);
          _videoControllers[index]!.play();
        }
      });
    }
  }
}

  @override
  void didUpdateWidget(VideoCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle open state changes with animations
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _animationController.forward();
        _fadeController.forward();
        // Initialize video controllers when opening
        _initializeVideoControllers();
      } else {
        _animationController.reverse();
        _fadeController.reverse();
        // Pause all videos when closing
        _pauseAllVideos();
      }
    }
  }

  /// Navigates to the next video in the carousel
  void nextVideo() {
    if (currentVideoIndex < (widget.boarding?.boardingImages.length ?? 1) - 1) {
      // Pause current video before switching
      _pauseCurrentVideo();

      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      HapticFeedback.lightImpact();
    }
  }

  /// Navigates to the previous video in the carousel
  void prevVideo() {
    if (currentVideoIndex > 0) {
      // Pause current video before switching
      _pauseCurrentVideo();

      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      HapticFeedback.lightImpact();
    }
  }

  /// Toggles play/pause state for the currently displayed video
void _toggleVideoPlayback() {
  if (_videoControllers[currentVideoIndex] != null &&
      _videoInitialized[currentVideoIndex]) {
    final controller = _videoControllers[currentVideoIndex]!;

    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
        _isPlaying[currentVideoIndex] = false;
      } else {
        controller.play();
        _isPlaying[currentVideoIndex] = true;
      }
    });

    HapticFeedback.selectionClick();
  }
}

  /// Pauses the currently displayed video
  void _pauseCurrentVideo() {
    if (_videoControllers[currentVideoIndex] != null &&
        _videoInitialized[currentVideoIndex]) {
      _videoControllers[currentVideoIndex]!.pause();
      setState(() {
        _isPlaying[currentVideoIndex] = false;
      });
    }
  }

  /// Pauses all videos - useful when closing the dialog
  void _pauseAllVideos() {
    for (int i = 0; i < _videoControllers.length; i++) {
      if (_videoControllers[i] != null && _videoInitialized[i]) {
        _videoControllers[i]!.pause();
        _isPlaying[i] = false;
      }
    }
  }

  /// Opens the enhanced share sheet for video sharing
  void _openEnhancedShareSheet(String videoUrl) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildEnhancedShareSheet(videoUrl),
    );
  }

  /// Builds the enhanced share sheet with platform options
  Widget _buildEnhancedShareSheet(String videoUrl) {
    final shareOptions = [
      {
        'title': isArabic() ? 'فيسبوك' : 'Facebook',
        'platform': 'facebook',
        'icon': Icons.facebook,
        'color': const Color(0xFF1877F2),
        'darkColor': const Color(0xFF4267B2),
      },
      {
        'title': isArabic() ? 'انستقرام' : 'Instagram',
        'platform': 'instagram',
        'icon': Icons.camera_alt_rounded,
        'color': const Color(0xFFE4405F),
        'darkColor': const Color(0xFFC13584),
      },
      {
        'title': isArabic() ? 'واتساب' : 'WhatsApp',
        'platform': 'whatsapp',
        'icon': Icons.message_rounded,
        'color': const Color(0xFF25D366),
        'darkColor': const Color(0xFF128C7E),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              widget.isDarkMode
                  ? [Colors.grey.shade900, Colors.grey.shade800]
                  : [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color:
              widget.isDarkMode
                  ? Colors.grey.shade700.withOpacity(0.5)
                  : Colors.grey.shade200.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color:
                widget.isDarkMode
                    ? Colors.black.withOpacity(0.6)
                    : Colors.black.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar for visual feedback
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    widget.isDarkMode
                        ? [Colors.grey.shade600, Colors.grey.shade500]
                        : [Colors.grey.shade400, Colors.grey.shade300],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header section with video icon and title
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  widget.isDarkMode
                      ? Colors.grey.shade800.withOpacity(0.3)
                      : Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          widget.isDarkMode
                              ? [Colors.blue.shade700, Colors.blue.shade800]
                              : [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic() ? 'مشاركة الفيديو' : 'Share Video',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _textPrimaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.isDarkMode
                                  ? Colors.grey.shade700.withOpacity(0.5)
                                  : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isArabic()
                              ? 'اختر منصة للمشاركة'
                              : 'Choose platform to share',
                          style: TextStyle(
                            fontSize: 13,
                            color: _textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Share platform options grid
          Padding(
            padding: const EdgeInsets.all(24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: shareOptions.length,
              itemBuilder: (context, index) {
                final option = shareOptions[index];
                final platformColor =
                    widget.isDarkMode
                        ? (option['darkColor'] as Color)
                        : (option['color'] as Color);

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          widget.isDarkMode
                              ? [Colors.grey.shade800, Colors.grey.shade900]
                              : [Colors.white, Colors.grey.shade50],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color:
                          widget.isDarkMode
                              ? Colors.grey.shade700.withOpacity(0.5)
                              : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            widget.isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.onShare(videoUrl, option['platform'] as String);
                        Navigator.pop(context);
                        HapticFeedback.selectionClick();
                      },
                      borderRadius: BorderRadius.circular(18),
                      splashColor: platformColor.withOpacity(0.1),
                      highlightColor: platformColor.withOpacity(0.05),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    platformColor.withOpacity(0.2),
                                    platformColor.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: platformColor.withOpacity(0.3),
                                ),
                              ),
                              child: Icon(
                                option['icon'] as IconData,
                                color: platformColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                option['title'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: _textPrimaryColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: _textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox();

    final boarding = widget.boarding;
    if (boarding == null || boarding.boardingImages.isEmpty) {
      return _buildNoVideosDialog();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        widget.isDarkMode
                            ? [
                              Colors.grey.shade900,
                              Colors.grey.shade800,
                              Colors.black87,
                            ]
                            : [
                              Colors.white,
                              Colors.grey.shade50,
                              Colors.blue.shade50,
                            ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color:
                        widget.isDarkMode
                            ? Colors.grey.shade700.withOpacity(0.5)
                            : Colors.grey.shade200.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          widget.isDarkMode
                              ? Colors.black.withOpacity(0.7)
                              : Colors.black.withOpacity(0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEnhancedHeader(boarding),
                    _buildEnhancedVideoCarousel(boarding),
                    if (boarding.boardingImages.length > 1)
                      _buildEnhancedPageIndicators(boarding),
                    _buildEnhancedCloseButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the dialog shown when no videos are available
  Widget _buildNoVideosDialog() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        widget.isDarkMode
                            ? [Colors.grey.shade900, Colors.grey.shade800]
                            : [Colors.white, Colors.grey.shade50],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color:
                        widget.isDarkMode
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          widget.isDarkMode
                              ? Colors.black.withOpacity(0.6)
                              : Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              widget.isDarkMode
                                  ? [Colors.grey.shade800, Colors.grey.shade900]
                                  : [
                                    Colors.grey.shade100,
                                    Colors.grey.shade200,
                                  ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color:
                              widget.isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Icon(
                        Icons.videocam_off_rounded,
                        size: 70,
                        color:
                            widget.isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isArabic() ? 'لا توجد فيديوهات' : 'No Videos Found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _textPrimaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            widget.isDarkMode
                                ? Colors.grey.shade800.withOpacity(0.5)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isArabic()
                            ? 'لا توجد فيديوهات لهذه الإقامة.'
                            : 'No videos found for this boarding.',
                        style: TextStyle(
                          fontSize: 15,
                          color: _textSecondaryColor,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                widget.isDarkMode
                                    ? [
                                      Colors.blue.shade700,
                                      Colors.blue.shade800,
                                    ]
                                    : [
                                      Colors.blue.shade500,
                                      Colors.blue.shade600,
                                    ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => widget.onOpenChange(false),
                          icon: const Icon(Icons.close_rounded, size: 20),
                          label: Text(
                            isArabic() ? 'إغلاق' : 'Close',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the enhanced header section with video information
  Widget _buildEnhancedHeader(BoardingEntryEntity boarding) {
     final List<Map<String, dynamic>> videoList = boarding.boardingImages
    .where((vid) => vid['videoName'] != null && vid['videoName'].toString().isNotEmpty)
    .cast<Map<String, dynamic>>()
    .toList();
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              widget.isDarkMode
                  ? [
                    Colors.grey.shade800.withOpacity(0.7),
                    Colors.grey.shade900.withOpacity(0.3),
                  ]
                  : [Colors.blue.shade50, Colors.grey.shade50],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          bottom: BorderSide(
            color:
                widget.isDarkMode
                    ? Colors.grey.shade700.withOpacity(0.5)
                    : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    widget.isDarkMode
                        ? [Colors.blue.shade700, Colors.blue.shade800]
                        : [Colors.blue.shade400, Colors.blue.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.video_library_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic()
                      ? 'فيديوهات إقامة ${boarding.pet.name}'
                      : "${boarding.pet.name}'s Boarding Videos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textPrimaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          widget.isDarkMode
                              ? [Colors.grey.shade700, Colors.grey.shade800]
                              : [Colors.blue.shade100, Colors.blue.shade50],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          widget.isDarkMode
                              ? Colors.grey.shade600
                              : Colors.blue.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.videocam_rounded,
                        size: 16,
                        color:
                            widget.isDarkMode
                                ? Colors.blue.shade300
                                : Colors.blue.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${videoList.length} ${isArabic() ? "فيديو" : "videos"}',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              widget.isDarkMode
                                  ? Colors.blue.shade300
                                  : Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main video carousel with navigation and controls
  Widget _buildEnhancedVideoCarousel(BoardingEntryEntity boarding) {
     final List<Map<String, dynamic>> videoList = boarding.boardingImages
    .where((vid) => vid['VideoName'] != null && vid['VideoName'].toString().isNotEmpty)
    .cast<Map<String, dynamic>>()
    .toList();
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          // Main PageView for video carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              // Pause previous video and update current index
              _pauseCurrentVideo();
              setState(() {
                currentVideoIndex = index;
              });

              // Initialize the new video controller if not already done
              _initializeVideoController(index);

              HapticFeedback.selectionClick();
            },
            itemCount: boarding.boardingImages.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Navigate to full-screen video detail
                        navigateToScreen(
                          context,
                          VideoDetailSimple(
                            path:
                                imageUrlWithVetICare +
                                videoList[index]['VideoName'],
                            title:
                                isArabic() ? 'تفاصيل الفيديو' : 'Video details',
                            description:
                                videoList[index]['note'] ?? '',
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Video player or loading/error state
                              _buildVideoPlayer(index, boarding),

                              // Enhanced gradient overlay for better control visibility
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      _overlayColor.withOpacity(0.4),
                                      Colors.transparent,
                                      Colors.transparent,
                                      _overlayColor.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),

                              // Play/Pause button overlay
                              if (_videoInitialized[index])
                                Center(
                                  child: GestureDetector(
                                    onTap: _toggleVideoPlayback,
                                    child: AnimatedOpacity(
                                      opacity: _isPlaying[index] ? 0.0 : 0.8,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          _isPlaying[index]
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Video note/description
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      videoList[index]['note'] ?? '',
                      style: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),

          // Enhanced Navigation buttons for multiple videos
          if (videoList.length > 1) ...[
            Positioned(
              left: 20,
              top: 0,
              bottom: 50, 
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_overlayColor, _overlayColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: currentVideoIndex > 0 ? prevVideo : null,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 0,
              bottom: 50, // Account for video description
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_overlayColor, _overlayColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed:
                        currentVideoIndex < videoList.length - 1
                            ? nextVideo
                            : null,
                  ),
                ),
              ),
            ),
          ],

          // Enhanced Share button
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_overlayColor, _overlayColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.share_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed:
                    () => _openEnhancedShareSheet(
                      imageUrlWithVetICare +
                         videoList[currentVideoIndex]['VideoName'],
                    ),
              ),
            ),
          ),
          // Enhanced Video counter
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_overlayColor, _overlayColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${currentVideoIndex + 1}/${videoList.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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

  /// Builds the video player widget with loading and error states
Widget _buildVideoPlayer(int index, BoardingEntryEntity boarding) {
 final List<Map<String, dynamic>> videoList = boarding.boardingImages
    .where((vid) => vid['VideoName'] != null && vid['VideoName'].toString().isNotEmpty)
    .cast<Map<String, dynamic>>()
    .toList();

  if (index >= videoList.length) {
    return const Center(child: Text("No video available"));
  }

  if (_videoControllers[index] == null) {
    _initializeVideoController(index);
    return _buildLoadingState();
  }

  if (!_videoInitialized[index]) {
    return _buildLoadingState();
  }

  if (_videoControllers[index]!.value.hasError) {
    return _buildErrorState(index);
  }

  return FittedBox(
    fit: BoxFit.cover,
    child: SizedBox(
      width: _videoControllers[index]!.value.size.width,
      height: _videoControllers[index]!.value.size.height,
      child: VideoPlayer(_videoControllers[index]!),
    ),
  );
}

Widget _buildLoadingState() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [_shimmerBaseColor, _shimmerHighlightColor, _shimmerBaseColor],
        stops: const [0.0, 0.5, 1.0],
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: widget.isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            isArabic() ? 'جاري التحميل...' : 'Loading video...',
            style: TextStyle(
              color: _textSecondaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildErrorState(int index) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: widget.isDarkMode
            ? [Colors.grey.shade800, Colors.grey.shade900]
            : [Colors.grey.shade200, Colors.grey.shade300],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: widget.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isArabic() ? 'فشل في تحميل الفيديو' : 'Failed to load video',
          style: TextStyle(
            color: _textSecondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _videoInitialized[index] = false;
              _videoControllers[index] = null;
            });
            _initializeVideoController(index);
          },
          child: Text(
            isArabic() ? 'اضغط لإعادة المحاولة' : 'Tap to retry',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600,
              fontSize: 12,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildEnhancedPageIndicators(BoardingEntryEntity boarding) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          boarding.boardingImages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: currentVideoIndex == index ? 32 : 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient:
                  currentVideoIndex == index
                      ? LinearGradient(
                        colors:
                            widget.isDarkMode
                                ? [Colors.blue.shade400, Colors.blue.shade600]
                                : [Colors.blue.shade500, Colors.blue.shade700],
                      )
                      : null,
              color:
                  currentVideoIndex != index
                      ? (widget.isDarkMode
                          ? Colors.grey.shade600
                          : Colors.grey.shade300)
                      : null,
              boxShadow:
                  currentVideoIndex == index
                      ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the enhanced close button
  Widget _buildEnhancedCloseButton() {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  widget.isDarkMode
                      ? [Colors.grey.shade700, Colors.grey.shade800]
                      : [Colors.grey.shade200, Colors.grey.shade300],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color:
                  widget.isDarkMode
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    widget.isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => widget.onOpenChange(false),
            icon: Icon(Icons.close_rounded, size: 22, color: _textPrimaryColor),
            label: Text(
              isArabic() ? 'إغلاق' : 'Close',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _textPrimaryColor,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of all video controllers to prevent memory leaks
    for (VideoPlayerController? controller in _videoControllers) {
      controller?.dispose();
    }

    // Dispose of animation controllers
    _pageController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();

    super.dispose();
  }
}

void showEnhancedDarkModeVideoCarousel(
  BuildContext context,
  BoardingEntryEntity? boarding,
  void Function(String videoUrl, String platform) onShare, {
  bool isDarkMode = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: isDarkMode ? Colors.black87 : Colors.black54,
    builder:
        (context) => VideoCarouselWidget(
          open: true,
          onOpenChange: (open) {
            if (!open) Navigator.of(context).pop();
          },
          boarding: boarding,
          onShare: onShare,
          isDarkMode: isDarkMode,
        ),
  );
}

/// Auto-detects theme and shows video carousel
void showThemeAwareEnhancedVideoCarousel(
  BuildContext context,
  BoardingEntryEntity? boarding,
  void Function(String videoUrl, String platform) onShare,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showEnhancedDarkModeVideoCarousel(
    context,
    boarding,
    onShare,
    isDarkMode: isDark,
  );
}
