// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/global_widget/boarding_video_details.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/boarding_entry_entity.dart';

// قائمة ثابتة للفيديوهات من الأصول
final List<Map<String, String>> staticVideos = [
  {'path': 'assets/video/cute_pets.mp4', 'note': 'Cute pets playing'},
  {'path': 'assets/video/funny_pets.mp4', 'note': 'Funny pets moments'},
];

class VideoCarouselWidget extends StatefulWidget {
  final bool open;
  final void Function(bool) onOpenChange;
  final BoardingEntryEntity? boarding;
  final void Function(String videoUrl, String platform) onShare;
  final bool isDarkMode;

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
  late PageController _pageController;
  int currentVideoIndex = 0;
  List<VideoPlayerController> _videoControllers = [];
  List<bool> _isVideoLoading = [];
  List<bool> _isVideoPlaying = [];

  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // نظام ألوان محسّن للوضع المظلم
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupAnimations();
    _initializeVideoControllers();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    if (widget.open) {
      _animationController.forward();
      _fadeController.forward();
    }
  }

  void _initializeVideoControllers() {
    _isVideoLoading = List<bool>.filled(staticVideos.length, true);
    _isVideoPlaying = List<bool>.filled(staticVideos.length, false);

    _videoControllers =
        staticVideos.asMap().entries.map((entry) {
          final index = entry.key;
          final video = entry.value;
          final controller = VideoPlayerController.asset(video['path']!);

          controller
              .initialize()
              .then((_) {
                if (mounted) {
                  setState(() {
                    _isVideoLoading[index] = false;
                  });
                  controller.setLooping(true);

                  // تشغيل الفيديو الأول فقط عند البداية
                  if (index == currentVideoIndex && index == 0) {
                    _playVideo(index);
                  }
                }
              })
              .catchError((error) {
                if (mounted) {
                  setState(() {
                    _isVideoLoading[index] = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error loading video: ${video['path']}'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              });
          return controller;
        }).toList();
  }

  // تشغيل فيديو معين وإيقاف الباقي
  void _playVideo(int index) {
    if (index >= 0 && index < _videoControllers.length && mounted) {
      // إيقاف جميع الفيديوهات الأخرى
      _stopAllVideos();

      // تشغيل الفيديو المحدد
      if (_videoControllers[index].value.isInitialized) {
        _videoControllers[index].play();
        setState(() {
          _isVideoPlaying[index] = true;
        });
      }
    }
  }

  // إيقاف جميع الفيديوهات
  void _stopAllVideos() {
    for (int i = 0; i < _videoControllers.length; i++) {
      if (_videoControllers[i].value.isInitialized && _isVideoPlaying[i]) {
        _videoControllers[i].pause();
        setState(() {
          _isVideoPlaying[i] = false;
        });
      }
    }
  }

  // تبديل حالة التشغيل/الإيقاف للفيديو الحالي
  void _toggleVideoPlayback() {
    if (currentVideoIndex >= 0 &&
        currentVideoIndex < _videoControllers.length &&
        _videoControllers[currentVideoIndex].value.isInitialized) {
      if (_isVideoPlaying[currentVideoIndex]) {
        _videoControllers[currentVideoIndex].pause();
        setState(() {
          _isVideoPlaying[currentVideoIndex] = false;
        });
      } else {
        _playVideo(currentVideoIndex);
      }
      HapticFeedback.selectionClick();
    }
  }

  @override
  void didUpdateWidget(VideoCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _animationController.forward();
        _fadeController.forward();
        // تشغيل الفيديو الحالي عند فتح المعرض
        if (_videoControllers.isNotEmpty) {
          _playVideo(currentVideoIndex);
        }
      } else {
        _animationController.reverse();
        _fadeController.reverse();
        // إيقاف جميع الفيديوهات عند إغلاق المعرض
        _stopAllVideos();
      }
    }
  }

  void nextVideo() {
    if (currentVideoIndex < staticVideos.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      HapticFeedback.lightImpact();
    }
  }

  void prevVideo() {
    if (currentVideoIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      HapticFeedback.lightImpact();
    }
  }

  void _openEnhancedShareSheet(String videoUrl) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildEnhancedShareSheet(videoUrl),
    );
  }

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

    if (staticVideos.isEmpty) {
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
                    _buildEnhancedHeader(),
                    _buildEnhancedVideoCarousel(),
                    if (staticVideos.length > 1) _buildEnhancedPageIndicators(),
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

  Widget _buildEnhancedHeader() {
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
                  isArabic() ? 'فيديوهات الإقامة' : 'Boarding Videos',
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
                        '${staticVideos.length} ${isArabic() ? "فيديو" : "videos"}',
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

  Widget _buildEnhancedVideoCarousel() {
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              // إيقاف الفيديو السابق وتشغيل الجديد
              _playVideo(index);
              setState(() {
                currentVideoIndex = index;
              });
              HapticFeedback.selectionClick();
            },
            itemCount: staticVideos.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigateToScreen(
                          context,
                          VideoDetailSimple(
                            path: staticVideos[index]['path']!,
                            title:
                                isArabic() ? 'تفاصيل الفيديو' : 'Video details',
                            description: staticVideos[index]['note'] ?? '',
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
                              _isVideoLoading[index]
                                  ? Container(
                                    color: _shimmerBaseColor,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color:
                                                widget.isDarkMode
                                                    ? Colors.blue.shade400
                                                    : Colors.blue.shade600,
                                            strokeWidth: 3,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            isArabic()
                                                ? 'جاري تحميل الفيديو...'
                                                : 'Loading video...',
                                            style: TextStyle(
                                              color: _textSecondaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : VideoPlayer(_videoControllers[index]),
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
                              // زر التشغيل/الإيقاف في الوسط
                              Center(
                                child: GestureDetector(
                                  onTap: _toggleVideoPlayback,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      _isVideoPlaying[index]
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 40,
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
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      staticVideos[index]['note'] ?? '',
                      style: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
          if (staticVideos.length > 1) ...[
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
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
              bottom: 0,
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
                        currentVideoIndex < staticVideos.length - 1
                            ? nextVideo
                            : null,
                  ),
                ),
              ),
            ),
          ],
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
                      staticVideos[currentVideoIndex]['path']!,
                    ),
              ),
            ),
          ),
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
                    '${currentVideoIndex + 1}/${staticVideos.length}',
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

  Widget _buildEnhancedPageIndicators() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          staticVideos.length,
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
            onPressed: () {
              // إيقاف جميع الفيديوهات قبل الإغلاق
              _stopAllVideos();
              widget.onOpenChange(false);
            },
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
    _pageController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();

    for (var controller in _videoControllers) {
      controller.pause();
      controller.dispose();
    }
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
