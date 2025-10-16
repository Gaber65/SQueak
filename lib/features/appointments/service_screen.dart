import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/all_apointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/get_supplier.dart';

class CareHubScreen extends StatefulWidget {
  const CareHubScreen({super.key});

  @override
  State<CareHubScreen> createState() => _CareHubScreenState();
}

class _CareHubScreenState extends State<CareHubScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _listAnimationController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  Future<void> _launchVetICareWebsite() async {
    final Uri url = Uri.parse('https://veticareapp.com/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Handle error - could show a snackbar or dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open VetICare website'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == "ar";

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final textScale = width / 375;
    final paddingScale = width / 400;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            isArabic ? "الرعاية" : "Care",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 24 * textScale.clamp(0.9, 1.3),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          iconTheme: IconThemeData(
            color: isDark ? Colors.white : Colors.black87,
            size: 28,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDark
                      ? [
                        const Color(0xFF0F0F0F),
                        const Color(0xFF1A1A1A),
                        const Color(0xFF2D2D2D),
                      ]
                      : [
                        const Color(0xFFF8FAFC),
                        const Color(0xFFF1F5F9),
                        const Color(0xFFE2E8F0),
                      ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0 * paddingScale.clamp(0.8, 1.2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12 * paddingScale),

                      // Hero Section - Compact
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16 * paddingScale,
                          vertical: 16 * paddingScale,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              ColorManager.primaryColor.withOpacity(0.08),
                              ColorManager.primaryColor.withOpacity(0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: ColorManager.primaryColor.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: ColorManager.primaryColor,
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isArabic
                                    ? "مركز رعاية صديقك"
                                    : "Care Hub",
                                style: TextStyle(
                                  fontSize: 18 * textScale.clamp(0.9, 1.2),
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isDark
                                          ? Colors.white
                                          : Colors.black87,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24 * paddingScale),

                      // Services Grid
                      Text(
                        isArabic ? "خدمات الرعاية" : "Care Services",
                        style: TextStyle(
                          fontSize: 20 * textScale.clamp(0.9, 1.3),
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 20 * paddingScale),

                      _buildAnimatedListItem(
                        index: 0,
                        child: _buildModernFeatureCard(
                          context: context,
                          isDark: isDark,
                          isArabic: isArabic,
                          height: height * 0.18,
                          width: width,
                          title: isArabic ? "العيادات" : "Clinics",
                          subtitle: isArabic ? "ابحث واحجز" : "Find & Book",
                          description: isArabic
                              ? "اعثر بسهولة واحجز مواعيد في العيادات البيطرية الموثوقة عبر VetICare لصديقك"
                              : "Easily find and book appointments at trusted veterinary clinics through VetICare for your friend",
                          icon: Icons.health_and_safety_rounded,
                          gradientColors: [
                            const Color(0xFF667EEA),
                            const Color(0xFF764BA2),
                          ],
                          onTap: () {
                            navigateToScreen(
                              context,
                              MySupplierScreen(petSelectFromIcon: null),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 16 * paddingScale),

                      _buildAnimatedListItem(
                        index: 1,
                        child: _buildModernFeatureCard(
                          context: context,
                          isDark: isDark,
                          isArabic: isArabic,
                          height: height * 0.18,
                          width: width,
                          title: isArabic ? "المواعيد" : "Appointments",
                          subtitle:
                              isArabic ? "إدارة المواعيد" : "Manage Schedule",
                          description: isArabic
                              ? "عرض وإدارة مواعيد صديقك القادمة."
                              : "View and manage your friend's upcoming appointments.",
                          icon: IconlyBold.calendar,
                          gradientColors: [
                            const Color(0xFFF093FB),
                            const Color(0xFFF5576C),
                          ],
                          onTap: () {
                            navigateToScreen(context, const AllAppointment());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFeatureCard({
    required BuildContext context,
    required bool isDark,
    required bool isArabic,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    required double width,
    required double height,
  }) {
    final textScale = width / 375;
    final paddingScale = width / 400;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.grey.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [const Color(0xFF2A2A2A), const Color(0xFF1F1F1F)]
                        : [Colors.white, const Color(0xFFFAFAFA)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Background gradient overlay
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          gradientColors[0].withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(16 * paddingScale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon and subtitle row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: gradientColors),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: gradientColors[0].withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(icon, color: Colors.white, size: 28),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18 * textScale.clamp(0.9, 1.2),
                                    fontWeight: FontWeight.w700,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 13 * textScale.clamp(0.9, 1.1),
                                    fontWeight: FontWeight.w600,
                                    color: gradientColors[0],
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12 * paddingScale),

                      // Description
                      Flexible(
                        child: _buildDescriptionText(
                          description: description,
                          isDark: isDark,
                          textScale: textScale,
                          isArabic: isArabic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedListItem({required int index, required Widget child}) {
    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        final delay = (index * 0.1).clamp(0.0, 1.0);
        final animation = CurvedAnimation(
          parent: _listAnimationController,
          curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: animation,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildDescriptionText({
    required String description,
    required bool isDark,
    required double textScale,
    required bool isArabic,
  }) {
    // Check if description contains VetICare
    if (description.contains('VetICare')) {
      final parts = description.split('VetICare');
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14 * textScale.clamp(0.9, 1.2),
            color: isDark ? Colors.grey[300] : Colors.grey[700],
            height: 1.5,
            letterSpacing: 0.2,
          ),
          children: [
            TextSpan(text: parts[0]),
            WidgetSpan(
              child: GestureDetector(
                onTap: _launchVetICareWebsite,
                child: Text(
                  'VetICare',
                  style: TextStyle(
                    fontSize: 14 * textScale.clamp(0.9, 1.2),
                    color: ColorManager.primaryColor,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorManager.primaryColor,
                  ),
                ),
              ),
            ),
            TextSpan(text: parts.length > 1 ? parts[1] : ''),
          ],
        ),
      );
    } else {
      return Text(
        description,
        style: TextStyle(
          fontSize: 14 * textScale.clamp(0.9, 1.2),
          color: isDark ? Colors.grey[300] : Colors.grey[700],
          height: 1.5,
          letterSpacing: 0.2,
        ),
      );
    }
  }
}
