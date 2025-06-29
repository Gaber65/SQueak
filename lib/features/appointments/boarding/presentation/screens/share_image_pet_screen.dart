import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import '../../domain/entities/boarding_entry_entity.dart';

class ImageCarouselWidget extends StatefulWidget {
  final bool open;
  final void Function(bool) onOpenChange;
  final BoardingEntryEntity? boarding;
  final void Function(String imageUrl, String platform) onShare;
  final bool isDarkMode;

  const ImageCarouselWidget({
    super.key,
    required this.open,
    required this.onOpenChange,
    required this.boarding,
    required this.onShare,
    required   this.isDarkMode ,
  });

  @override
  State<ImageCarouselWidget> createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int currentImageIndex = 0;
  bool isImageLoading = true;
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  // Enhanced Dark Mode Color Scheme
  ColorScheme get _colorScheme => widget.isDarkMode
      ? const ColorScheme.dark()
      : const ColorScheme.light();

  Color get _backgroundColor => widget.isDarkMode
      ? Colors.grey.shade900
      : Colors.white;

  Color get _surfaceColor => widget.isDarkMode
      ? Colors.grey.shade800
      : Colors.grey.shade50;

  Color get _cardColor => widget.isDarkMode
      ? Colors.grey.shade800
      : Colors.white;

  Color get _borderColor => widget.isDarkMode
      ? Colors.grey.shade700
      : Colors.grey.shade200;

  Color get _textPrimaryColor => widget.isDarkMode
      ? Colors.white
      : Colors.black87;

  Color get _textSecondaryColor => widget.isDarkMode
      ? Colors.grey.shade400
      : Colors.grey.shade600;

  Color get _iconColor => widget.isDarkMode
      ? Colors.grey.shade300
      : Colors.grey.shade700;

  Color get _overlayColor => widget.isDarkMode
      ? Colors.black.withOpacity(0.7)
      : Colors.black.withOpacity(0.5);

  Color get _shimmerBaseColor => widget.isDarkMode
      ? Colors.grey.shade800
      : Colors.grey.shade300;

  Color get _shimmerHighlightColor => widget.isDarkMode
      ? Colors.grey.shade700
      : Colors.grey.shade100;

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

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.open) {
      _animationController.forward();
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(ImageCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _animationController.forward();
        _fadeController.forward();
      } else {
        _animationController.reverse();
        _fadeController.reverse();
      }
    }
  }

  void nextImage() {
    if (currentImageIndex < (widget.boarding?.boardingImages.length ?? 1) - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      HapticFeedback.lightImpact();
    }
  }

  void prevImage() {
    if (currentImageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      HapticFeedback.lightImpact();
    }
  }

  void _openEnhancedShareSheet(String imageUrl) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildEnhancedShareSheet(imageUrl),
    );
  }

  Widget _buildEnhancedShareSheet(String imageUrl) {
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
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade900,
            Colors.grey.shade800,
          ]
              : [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: widget.isDarkMode
              ? Colors.grey.shade700.withOpacity(0.5)
              : Colors.grey.shade200.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode
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
          // Enhanced Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isDarkMode
                    ? [Colors.grey.shade600, Colors.grey.shade500]
                    : [Colors.grey.shade400, Colors.grey.shade300],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Enhanced Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? Colors.grey.shade800.withOpacity(0.3)
                  : Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isDarkMode
                          ? [
                        Colors.blue.shade700,
                        Colors.blue.shade800,
                      ]
                          : [
                        Colors.blue.shade400,
                        Colors.blue.shade600,
                      ],
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
                        isArabic() ? 'مشاركة الصورة' : 'Share Image',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _textPrimaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode
                              ? Colors.grey.shade700.withOpacity(0.5)
                              : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isArabic() ? 'اختر منصة للمشاركة' : 'Choose platform to share',
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

          // Enhanced Share options
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
                final platformColor = widget.isDarkMode
                    ? (option['darkColor'] as Color)
                    : (option['color'] as Color);

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isDarkMode
                          ? [
                        Colors.grey.shade800,
                        Colors.grey.shade900,
                      ]
                          : [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: widget.isDarkMode
                          ? Colors.grey.shade700.withOpacity(0.5)
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isDarkMode
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
                        widget.onShare(imageUrl, option['platform'] as String);
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
      return _buildNoImagesDialog();
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
                    colors: widget.isDarkMode
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
                    color: widget.isDarkMode
                        ? Colors.grey.shade700.withOpacity(0.5)
                        : Colors.grey.shade200.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
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
                    _buildEnhancedImageCarousel(boarding),
                    if (boarding.boardingImages.length > 1) _buildEnhancedPageIndicators(boarding),
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

  Widget _buildNoImagesDialog() {
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
                    colors: widget.isDarkMode
                        ? [
                      Colors.grey.shade900,
                      Colors.grey.shade800,
                    ]
                        : [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: widget.isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
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
                          colors: widget.isDarkMode
                              ? [
                            Colors.grey.shade800,
                            Colors.grey.shade900,
                          ]
                              : [
                            Colors.grey.shade100,
                            Colors.grey.shade200,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: widget.isDarkMode
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        size: 70,
                        color: widget.isDarkMode
                            ? Colors.grey.shade500
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isArabic() ? 'لا توجد صور' : 'No Images Found',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _textPrimaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? Colors.grey.shade800.withOpacity(0.5)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isArabic()
                            ? 'لا توجد صور لهذه الإقامة.'
                            : 'No images found for this boarding.',
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
                            colors: widget.isDarkMode
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

  Widget _buildEnhancedHeader(BoardingEntryEntity boarding) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade800.withOpacity(0.7),
            Colors.grey.shade900.withOpacity(0.3),
          ]
              : [
            Colors.blue.shade50,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          bottom: BorderSide(
            color: widget.isDarkMode
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
                colors: widget.isDarkMode
                    ? [
                  Colors.blue.shade700,
                  Colors.blue.shade800,
                ]
                    : [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
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
              Icons.photo_library_rounded,
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
                      ? 'صور إقامة ${boarding.pet.name}'
                      : "${boarding.pet.name}'s Boarding Photos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textPrimaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isDarkMode
                          ? [
                        Colors.grey.shade700,
                        Colors.grey.shade800,
                      ]
                          : [
                        Colors.blue.shade100,
                        Colors.blue.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.isDarkMode
                          ? Colors.grey.shade600
                          : Colors.blue.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_rounded,
                        size: 16,
                        color: widget.isDarkMode
                            ? Colors.blue.shade300
                            : Colors.blue.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${boarding.boardingImages.length} ${isArabic() ? "صورة" : "photos"}',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.isDarkMode
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

  Widget _buildEnhancedImageCarousel(BoardingEntryEntity boarding) {
    return Container(
      height: 350,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentImageIndex = index;
              });
              HapticFeedback.selectionClick();
            },
            itemCount: boarding.boardingImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        boarding.boardingImages[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _shimmerBaseColor,
                                  _shimmerHighlightColor,
                                  _shimmerBaseColor,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: widget.isDarkMode
                                        ? Colors.blue.shade400
                                        : Colors.blue.shade600,
                                    strokeWidth: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isArabic() ? 'جاري التحميل...' : 'Loading...',
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
                        },
                        errorBuilder: (context, error, _) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.isDarkMode
                                  ? [
                                Colors.grey.shade800,
                                Colors.grey.shade900,
                              ]
                                  : [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: widget.isDarkMode
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  size: 60,
                                  color: widget.isDarkMode
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                isArabic() ? 'فشل في تحميل الصورة' : 'Failed to load image',
                                style: TextStyle(
                                  color: _textSecondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isArabic() ? 'اضغط لإعادة المحاولة' : 'Tap to retry',
                                style: TextStyle(
                                  color: _textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Enhanced gradient overlay
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
                    ],
                  ),
                ),
              );
            },
          ),

          // Enhanced Navigation buttons
          if (boarding.boardingImages.length > 1) ...[
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _overlayColor,
                        _overlayColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
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
                    onPressed: currentImageIndex > 0 ? prevImage : null,
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
                      colors: [
                        _overlayColor,
                        _overlayColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
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
                    onPressed: currentImageIndex < boarding.boardingImages.length - 1 ? nextImage : null,
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
                  colors: [
                    _overlayColor,
                    _overlayColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white, size: 24),
                onPressed: () => _openEnhancedShareSheet(boarding.boardingImages[currentImageIndex]),
              ),
            ),
          ),

          // Enhanced Image counter
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _overlayColor,
                    _overlayColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
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
                  Icon(
                    Icons.photo_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${currentImageIndex + 1}/${boarding.boardingImages.length}',
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
            width: currentImageIndex == index ? 32 : 10,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: currentImageIndex == index
                  ? LinearGradient(
                colors: widget.isDarkMode
                    ? [Colors.blue.shade400, Colors.blue.shade600]
                    : [Colors.blue.shade500, Colors.blue.shade700],
              )
                  : null,
              color: currentImageIndex != index
                  ? (widget.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300)
                  : null,
              boxShadow: currentImageIndex == index
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
              colors: widget.isDarkMode
                  ? [
                Colors.grey.shade700,
                Colors.grey.shade800,
              ]
                  : [
                Colors.grey.shade200,
                Colors.grey.shade300,
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isDarkMode
                  ? Colors.grey.shade600
                  : Colors.grey.shade400,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => widget.onOpenChange(false),
            icon: Icon(
              Icons.close_rounded,
              size: 22,
              color: _textPrimaryColor,
            ),
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
    super.dispose();
  }
}

// Enhanced usage functions
void showEnhancedDarkModeImageCarousel(
    BuildContext context,
    BoardingEntryEntity? boarding,
    void Function(String imageUrl, String platform) onShare, {
      bool isDarkMode = false,
    }) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: isDarkMode ? Colors.black87 : Colors.black54,
    builder: (context) => ImageCarouselWidget(
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

// Auto-detect theme version
void showThemeAwareEnhancedImageCarousel(
    BuildContext context,
    BoardingEntryEntity? boarding,
    void Function(String imageUrl, String platform) onShare,
    ) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showEnhancedDarkModeImageCarousel(context, boarding, onShare, isDarkMode: isDark);
}
