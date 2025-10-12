// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/network/end_points.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:squeak/core/service/global_widget/video_detail.dart';

import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import '../../domain/entities/boarding_entry_entity.dart';


/// Main widget for displaying image/video carousel in a dialog
class ImageCarouselWidget extends StatefulWidget {
  final bool open;
  final void Function(bool) onOpenChange;
  final BoardingEntryEntity? boarding;
  final void Function(String imageUrl, String platform) onShare;
  final bool isDarkMode;
  final bool isVideo;

  const ImageCarouselWidget({
    super.key,
    required this.open,
    required this.onOpenChange,
    required this.boarding,
    required this.onShare,
    required this.isVideo,
    required this.isDarkMode,
  });

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupAnimations();
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

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    if (widget.open) {
      _animationController.forward();
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(ImageCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      widget.open ? _animationController.forward() : _animationController.reverse();
      widget.open ? _fadeController.forward() : _fadeController.reverse();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Extract media list based on type
  List<Map<String, dynamic>> _getMediaList() {
    if (widget.boarding == null) return [];
    
    final key = widget.isVideo ? 'videoName' : 'imageName';
    return widget.boarding!.boardingImages
        .where((media) => media[key] != null && media[key].toString().isNotEmpty)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  void _navigatePage(bool next) {
    if (next && _currentIndex < _getMediaList().length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else if (!next && _currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
    HapticFeedback.lightImpact();
  }

  void _showShareSheet(String mediaUrl) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ShareSheet(
        mediaUrl: mediaUrl,
        isDarkMode: widget.isDarkMode,
        onShare: widget.onShare,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open) return const SizedBox.shrink();

    final mediaList = _getMediaList();
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            child: mediaList.isEmpty
                ? _NoMediaDialog(
                    isDarkMode: widget.isDarkMode,
                    isVideo: widget.isVideo,
                    onClose: () => widget.onOpenChange(false),
                  )
                : _MediaCarouselDialog(
                    mediaList: mediaList,
                    isDarkMode: widget.isDarkMode,
                    isVideo: widget.isVideo,
                    boarding: widget.boarding!,
                    currentIndex: _currentIndex,
                    pageController: _pageController,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    onNavigate: _navigatePage,
                    onShare: _showShareSheet,
                    onClose: () => widget.onOpenChange(false),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Dialog shown when no media is available
class _NoMediaDialog extends StatelessWidget {
  final bool isDarkMode;
  final bool isVideo;
  final VoidCallback onClose;

  const _NoMediaDialog({
    required this.isDarkMode,
    required this.isVideo,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _DialogTheme(isDarkMode);
    
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: theme.dialogGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.borderColor, width: 2),
        boxShadow: [theme.dialogShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: theme.secondaryGradient,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.borderColor),
            ),
            child: Icon(
              isVideo ? Icons.videocam_off_outlined : Icons.image_not_supported_rounded,
              size: 70,
              color: theme.iconColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isVideo
                ? (isArabic() ? 'لا توجد فيديو' : 'No Video Found')
                : (isArabic() ? 'لا توجد صور' : 'No Images Found'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.primaryTextColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.subtleBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isVideo
                  ? (isArabic() ? 'لا توجد فيديو لهذه الإقامة.' : 'No video found for this boarding.')
                  : (isArabic() ? 'لا توجد صور لهذه الإقامة.' : 'No images found for this boarding.'),
              style: TextStyle(
                fontSize: 15,
                color: theme.secondaryTextColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),
          _GradientButton(
            onPressed: onClose,
            icon: Icons.close_rounded,
            label: isArabic() ? 'إغلاق' : 'Close',
            gradient: theme.buttonGradient,
          ),
        ],
      ),
    );
  }
}

/// Main dialog containing the media carousel
class _MediaCarouselDialog extends StatelessWidget {
  final List<Map<String, dynamic>> mediaList;
  final bool isDarkMode;
  final bool isVideo;
  final BoardingEntryEntity boarding;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final void Function(bool next) onNavigate;
  final void Function(String url) onShare;
  final VoidCallback onClose;

  const _MediaCarouselDialog({
    required this.mediaList,
    required this.isDarkMode,
    required this.isVideo,
    required this.boarding,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.onNavigate,
    required this.onShare,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _DialogTheme(isDarkMode);
    
    return Container(
      decoration: BoxDecoration(
        gradient: theme.dialogGradient,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.borderColor, width: 2),
        boxShadow: [theme.dialogShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CarouselHeader(
            boarding: boarding,
            isDarkMode: isDarkMode,
            isVideo: isVideo,
            mediaCount: mediaList.length,
          ),
          _MediaCarousel(
            mediaList: mediaList,
            isDarkMode: isDarkMode,
            isVideo: isVideo,
            currentIndex: currentIndex,
            pageController: pageController,
            onPageChanged: onPageChanged,
            onNavigate: onNavigate,
            onShare: onShare,
          ),
          if (mediaList.length > 1)
            _PageIndicators(
              count: mediaList.length,
              currentIndex: currentIndex,
              isDarkMode: isDarkMode,
            ),
          _CloseButton(isDarkMode: isDarkMode, onClose: onClose),
        ],
      ),
    );
  }
}

/// Header section with pet info and media count
class _CarouselHeader extends StatelessWidget {
  final BoardingEntryEntity boarding;
  final bool isDarkMode;
  final bool isVideo;
  final int mediaCount;

  const _CarouselHeader({
    required this.boarding,
    required this.isDarkMode,
    required this.isVideo,
    required this.mediaCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _DialogTheme(isDarkMode);
    
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: theme.headerGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(bottom: BorderSide(color: theme.borderColor)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: theme.accentGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              isVideo ? Icons.video_camera_back_outlined : Icons.photo_library_rounded,
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
                  isVideo
                      ? (isArabic() ? 'فيديو إقامة ${boarding.pet.name}' : "${boarding.pet.name}'s Boarding Videos")
                      : (isArabic() ? 'صور إقامة ${boarding.pet.name}' : "${boarding.pet.name}'s Boarding Photos"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryTextColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: theme.badgeGradient,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.badgeBorderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isVideo ? Icons.video_camera_back_outlined : Icons.photo_rounded,
                        size: 16,
                        color: theme.accentTextColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$mediaCount ${isVideo ? (isArabic() ? "فيديو" : "video") : (isArabic() ? "صورة" : "photo")}',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.accentTextColor,
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
}

/// Media carousel with navigation and controls
class _MediaCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> mediaList;
  final bool isDarkMode;
  final bool isVideo;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final void Function(bool next) onNavigate;
  final void Function(String url) onShare;

  const _MediaCarousel({
    required this.mediaList,
    required this.isDarkMode,
    required this.isVideo,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.onNavigate,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _DialogTheme(isDarkMode);
    
    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              onPageChanged(index);
              HapticFeedback.selectionClick();
            },
            itemCount: mediaList.length,
            itemBuilder: (context, index) => _MediaItem(
              media: mediaList[index],
              isDarkMode: isDarkMode,
              isVideo: isVideo,
              theme: theme,
            ),
          ),
          
          // Navigation buttons
          if (mediaList.length > 1) ...[
            _NavigationButton(
              isLeft: true,
              enabled: currentIndex > 0,
              onPressed: () => onNavigate(false),
              theme: theme,
            ),
            _NavigationButton(
              isLeft: false,
              enabled: currentIndex < mediaList.length - 1,
              onPressed: () => onNavigate(true),
              theme: theme,
            ),
          ],
          
          // Share button
          if (!isVideo)
            _OverlayButton(
              top: 20,
              right: 20,
              icon: Icons.share_rounded,
              onPressed: () => onShare(
                imageUrlWithVetICare + mediaList[currentIndex]['imageName'],
              ),
              theme: theme,
            ),
          
          // Media counter
          _OverlayButton(
            top: 20,
            left: 20,
            icon: isVideo ? Icons.video_camera_back_outlined : Icons.photo_rounded,
            label: '${currentIndex + 1}/${mediaList.length}',
            theme: theme,
          ),
        ],
      ),
    );
  }
}

/// Individual media item (image or video)
class _MediaItem extends StatelessWidget {
  final Map<String, dynamic> media;
  final bool isDarkMode;
  final bool isVideo;
  final _DialogTheme theme;

  const _MediaItem({
    required this.media,
    required this.isDarkMode,
    required this.isVideo,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final mediaKey = isVideo ? 'videoName' : 'imageName';
    final mediaFileName = media[mediaKey];
    
    // For videos, try multiple URL patterns since the server might use different paths
    final mediaUrl = isVideo 
        ? _getVideoUrl(mediaFileName)
        : imageUrlWithVetICare + mediaFileName;
    
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isVideo ? null : () => _openImageDetail(context, mediaUrl, media['note'] ?? ''),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: isVideo
                    ? _buildVideo(mediaUrl, mediaFileName)
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildImage(mediaUrl),
                          _buildGradientOverlay(),
                        ],
                      ),
              ),
            ),
          ),
        ),
        if (media['note'] != null && media['note'].toString().isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              media['note'],
              style: TextStyle(
                color: theme.secondaryTextColor,
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
  }

  String _getVideoUrl(String fileName) {
    return imageUrlWithVetICare + fileName;
  }

  Widget _buildVideo(String url, String fileName) {
    // print(fileName);
    // print("url: $url");
    return Container(
      color: Colors.black,
      child: Center(
        child: _VideoPlayerWithFallback(
          primaryUrl: url,
          fallbackUrl: imageUrlWithVetICare + fileName, 
          theme: theme,
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _LoadingIndicator(
          progress: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
          theme: theme,
        );
      },
      errorBuilder: (context, error, _) => _ErrorWidget(theme: theme),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.overlayColor.withOpacity(0.4),
            Colors.transparent,
            Colors.transparent,
            theme.overlayColor.withOpacity(0.4),
          ],
        ),
      ),
    );
  }

  void _openImageDetail(BuildContext context, String url, String description) {
    navigateToScreen(
      context,
      ImageDetailSimple(
        path: url,
        title: isArabic() ? 'تفاصيل الصورة' : 'Image details',
        description: description,
      ),
    );
  }
}

/// Loading indicator for images
class _LoadingIndicator extends StatelessWidget {
  final double? progress;
  final _DialogTheme theme;

  const _LoadingIndicator({required this.progress, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.shimmerBaseColor,
            theme.shimmerHighlightColor,
            theme.shimmerBaseColor,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              color: theme.accentColor,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              isArabic() ? 'جاري التحميل...' : 'Loading...',
              style: TextStyle(
                color: theme.secondaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error widget for failed image loads
class _ErrorWidget extends StatelessWidget {
  final _DialogTheme theme;

  const _ErrorWidget({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: theme.secondaryGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.subtleBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.broken_image_rounded,
              size: 60,
              color: theme.iconColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isArabic() ? 'فشل في تحميل الصورة' : 'Failed to load image',
            style: TextStyle(
              color: theme.secondaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic() ? 'اضغط لإعادة المحاولة' : 'Tap to retry',
            style: TextStyle(
              color: theme.secondaryTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Video player with fallback URL support
class _VideoPlayerWithFallback extends StatefulWidget {
  final String primaryUrl;
  final String fallbackUrl;
  final _DialogTheme theme;

  const _VideoPlayerWithFallback({
    required this.primaryUrl,
    required this.fallbackUrl,
    required this.theme,
  });

  @override
  State<_VideoPlayerWithFallback> createState() => _VideoPlayerWithFallbackState();
}

class _VideoPlayerWithFallbackState extends State<_VideoPlayerWithFallback> {
  final bool _useFallback = false;

  @override
  Widget build(BuildContext context) {
    final videoUrl = _useFallback ? widget.fallbackUrl : widget.primaryUrl;
    
    return VideoStringApp(
      video: videoUrl,
      key: ValueKey(videoUrl), 
    );
  }
}

/// Navigation button for carousel
class _NavigationButton extends StatelessWidget {
  final bool isLeft;
  final bool enabled;
  final VoidCallback onPressed;
  final _DialogTheme theme;

  const _NavigationButton({
    required this.isLeft,
    required this.enabled,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isLeft ? 20 : null,
      right: !isLeft ? 20 : null,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: theme.overlayGradient,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [theme.overlayButtonShadow],
          ),
          child: IconButton(
            icon: Icon(
              isLeft ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              color: Colors.white,
              size: 32,
            ),
            onPressed: enabled ? onPressed : null,
          ),
        ),
      ),
    );
  }
}

/// Overlay button (share, counter)
class _OverlayButton extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final _DialogTheme theme;

  const _OverlayButton({
    this.top,
    this.left,
    this.right,
    required this.icon,
    this.label,
    this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: label != null
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          : null,
      decoration: BoxDecoration(
        gradient: theme.overlayGradient,
        borderRadius: BorderRadius.circular(label != null ? 25 : 30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [theme.overlayButtonShadow],
      ),
      child: label != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: Icon(icon, color: Colors.white, size: 24),
              onPressed: onPressed,
            ),
    );

    return Positioned(
      top: top,
      left: left,
      right: right,
      child: child,
    );
  }
}

/// Page indicators
class _PageIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;
  final bool isDarkMode;

  const _PageIndicators({
    required this.count,
    required this.currentIndex,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _DialogTheme(isDarkMode);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: currentIndex == index ? 32 : 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: currentIndex == index ? theme.accentGradient : null,
              color: currentIndex != index ? theme.inactiveIndicatorColor : null,
              boxShadow: currentIndex == index
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
}

/// Close button
class _CloseButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onClose;

  const _CloseButton({required this.isDarkMode, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = _DialogTheme(isDarkMode);
    
    return Padding(
      padding: const EdgeInsets.all(28),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: theme.closeButtonGradient,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.closeButtonBorderColor),
            boxShadow: [theme.buttonShadow],
          ),
          child: ElevatedButton.icon(
            onPressed: onClose,
            icon: Icon(Icons.close_rounded, size: 22, color: theme.primaryTextColor),
            label: Text(
              isArabic() ? 'إغلاق' : 'Close',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.primaryTextColor,
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
}

/// Share sheet bottom modal
class _ShareSheet extends StatelessWidget {
  final String mediaUrl;
  final bool isDarkMode;
  final void Function(String imageUrl, String platform) onShare;

  const _ShareSheet({
    required this.mediaUrl,
    required this.isDarkMode,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = _DialogTheme(isDarkMode);
    
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
        gradient: theme.dialogGradient,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: theme.borderColor.withOpacity(0.5)),
        boxShadow: [theme.sheetShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              gradient: theme.handleBarGradient,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.sheetHeaderColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: theme.accentGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic() ? 'مشاركة الصورة' : 'Share Image',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryTextColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.subtleBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isArabic() ? 'اختر منصة للمشاركة' : 'Choose platform to share',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.secondaryTextColor,
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
          
          // Share options
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
                final platformColor = isDarkMode
                    ? (option['darkColor'] as Color)
                    : (option['color'] as Color);

                return _ShareOptionButton(
                  option: option,
                  platformColor: platformColor,
                  theme: theme,
                  onTap: () {
                    onShare(mediaUrl, option['platform'] as String);
                    Navigator.pop(context);
                    HapticFeedback.selectionClick();
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Individual share option button
class _ShareOptionButton extends StatelessWidget {
  final Map<String, dynamic> option;
  final Color platformColor;
  final _DialogTheme theme;
  final VoidCallback onTap;

  const _ShareOptionButton({
    required this.option,
    required this.platformColor,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: theme.shareButtonGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.borderColor, width: 1.5),
        boxShadow: [theme.shareButtonShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                    border: Border.all(color: platformColor.withOpacity(0.3)),
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
                      color: theme.primaryTextColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: theme.secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient button widget
class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Gradient gradient;

  const _GradientButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
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
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(
            label,
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
    );
  }
}

/// Theme helper class for consistent styling
class _DialogTheme {
  final bool isDarkMode;

  _DialogTheme(this.isDarkMode);

  // Text colors
  Color get primaryTextColor => isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryTextColor => isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
  Color get accentTextColor => isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700;

  // Background colors
  Color get subtleBackgroundColor => isDarkMode 
      ? Colors.grey.shade800.withOpacity(0.5) 
      : Colors.grey.shade100;
  Color get sheetHeaderColor => isDarkMode
      ? Colors.grey.shade800.withOpacity(0.3)
      : Colors.blue.shade50;

  // Border colors
  Color get borderColor => isDarkMode 
      ? Colors.grey.shade700.withOpacity(0.5) 
      : Colors.grey.shade200.withOpacity(0.5);
  Color get badgeBorderColor => isDarkMode ? Colors.grey.shade600 : Colors.blue.shade200;
  Color get closeButtonBorderColor => isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;

  // Icon colors
  Color get iconColor => isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;

  // Overlay colors
  Color get overlayColor => isDarkMode 
      ? Colors.black.withOpacity(0.7) 
      : Colors.black.withOpacity(0.5);
  Color get accentColor => isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600;

  // Shimmer colors
  Color get shimmerBaseColor => isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
  Color get shimmerHighlightColor => isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100;

  // Indicator colors
  Color get inactiveIndicatorColor => isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300;

  // Gradients
  LinearGradient get dialogGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [Colors.grey.shade900, Colors.grey.shade800, Colors.black87]
            : [Colors.white, Colors.grey.shade50, Colors.blue.shade50],
      );

  LinearGradient get headerGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.grey.shade800.withOpacity(0.7), Colors.grey.shade900.withOpacity(0.3)]
            : [Colors.blue.shade50, Colors.grey.shade50],
      );

  LinearGradient get accentGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.blue.shade700, Colors.blue.shade800]
            : [Colors.blue.shade400, Colors.blue.shade600],
      );

  LinearGradient get badgeGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.grey.shade700, Colors.grey.shade800]
            : [Colors.blue.shade100, Colors.blue.shade50],
      );

  LinearGradient get secondaryGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.grey.shade800, Colors.grey.shade900]
            : [Colors.grey.shade100, Colors.grey.shade200],
      );

  LinearGradient get overlayGradient => LinearGradient(
        colors: [overlayColor, overlayColor.withOpacity(0.8)],
      );

  LinearGradient get closeButtonGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.grey.shade700, Colors.grey.shade800]
            : [Colors.grey.shade200, Colors.grey.shade300],
      );

  LinearGradient get buttonGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.blue.shade700, Colors.blue.shade800]
            : [Colors.blue.shade500, Colors.blue.shade600],
      );

  LinearGradient get shareButtonGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.grey.shade800, Colors.grey.shade900]
            : [Colors.white, Colors.grey.shade50],
      );

  LinearGradient get handleBarGradient => LinearGradient(
        colors: isDarkMode
            ? [Colors.grey.shade600, Colors.grey.shade500]
            : [Colors.grey.shade400, Colors.grey.shade300],
      );

  // Shadows
  BoxShadow get dialogShadow => BoxShadow(
        color: isDarkMode ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.15),
        blurRadius: 40,
        offset: const Offset(0, 20),
      );

  BoxShadow get overlayButtonShadow => BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      );

  BoxShadow get buttonShadow => BoxShadow(
        color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      );

  BoxShadow get shareButtonShadow => BoxShadow(
        color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      );

  BoxShadow get sheetShadow => BoxShadow(
        color: isDarkMode ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.1),
        blurRadius: 25,
        offset: const Offset(0, -8),
      );
}

// Helper functions
void showEnhancedImageCarousel(
  BuildContext context,
  BoardingEntryEntity? boarding,
  void Function(String imageUrl, String platform) onShare, {
  bool isVideo = false,
  bool? isDarkMode,
}) {
  final effectiveDarkMode = isDarkMode ?? Theme.of(context).brightness == Brightness.dark;
  
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: effectiveDarkMode ? Colors.black87 : Colors.black54,
    builder: (context) => ImageCarouselWidget(
      open: true,
      onOpenChange: (open) {
        if (!open) Navigator.of(context).pop();
      },
      boarding: boarding,
      onShare: onShare,
      isVideo: isVideo,
      isDarkMode: effectiveDarkMode,
    ),
  );
}