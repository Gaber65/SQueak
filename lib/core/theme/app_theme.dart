import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modern Material 3 theme system for Squeak app
/// Blue → Purple accent palette with clinic-grade aesthetic
class AppTheme {
  // Design tokens
  static const _primaryColor = Color(0xFF5B6CFF);
  static const _secondaryColor = Color(0xFF7A57D1);
  static const _backgroundColor = Color(0xFFF7F8FA);
  static const _surfaceColor = Color(0xFFFFFFFF);
  static const _errorColor = Color(0xFFD32F2F);
  
  // Supporting colors
  static const _successColor = Color(0xFF2E7D32);
  static const _warningColor = Color(0xFFED6C02);
  static const _infoColor = Color(0xFF0288D1);
  
  // Dark theme colors
  static const _darkPrimaryColor = Color(0xFF7C88FF);
  static const _darkSecondaryColor = Color(0xFF9B7DE0);
  static const _darkBackgroundColor = Color(0xFF121212);
  static const _darkSurfaceColor = Color(0xFF1E1E1E);
  
  // Spacing tokens
  static const spacing4 = 4.0;
  static const spacing8 = 8.0;
  static const spacing12 = 12.0;
  static const spacing16 = 16.0;
  static const spacing20 = 20.0;
  static const spacing24 = 24.0;
  static const spacing32 = 32.0;
  
  // Radius tokens
  static const radius8 = 8.0;
  static const radius12 = 12.0;
  static const radius16 = 16.0;
  static const radius20 = 20.0;
  
  // Elevation tokens
  static const elevation0 = 0.0;
  static const elevation1 = 1.0;
  static const elevation3 = 3.0;
  static const elevation6 = 6.0;

  /// Light theme configuration
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      onPrimary: Colors.white,
      secondary: _secondaryColor,
      onSecondary: Colors.white,
      surface: _surfaceColor,
      onSurface: Color(0xFF1C1B1F),
      background: _backgroundColor,
      onBackground: Color(0xFF1C1B1F),
      error: _errorColor,
      onError: Colors.white,
      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC4D0),
    ),
    
    // Typography with Inter/Roboto semantic scales
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.10,
        height: 1.43,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.40,
        height: 1.33,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.10,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
        height: 1.45,
      ),
    ),
    
    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: _surfaceColor,
      foregroundColor: const Color(0xFF1C1B1F),
      elevation: elevation0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1C1B1F),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    
    // Card theme
    cardTheme: CardTheme(
      color: _surfaceColor,
      elevation: elevation1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius12),
      ),
      margin: const EdgeInsets.all(spacing8),
    ),
    
    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing24,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
        ),
        elevation: elevation1,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    ),
    
    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryColor,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing24,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
        ),
        side: const BorderSide(color: _primaryColor),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    ),
    
    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryColor,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing12,
          vertical: spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    ),
    
    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: Color(0xFF79747E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: Color(0xFF79747E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: _errorColor),
      ),
      contentPadding: const EdgeInsets.all(spacing16),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF49454F),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF79747E),
      ),
    ),
    
    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _surfaceColor,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Color(0xFF79747E),
      type: BottomNavigationBarType.fixed,
      elevation: elevation3,
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 24),
    ),
    
    // FloatingActionButton theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: elevation6,
    ),
    
    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF313033),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: _backgroundColor,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacing12,
        vertical: spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius8),
      ),
    ),
  );

  /// Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryColor,
      onPrimary: Color(0xFF000000),
      secondary: _darkSecondaryColor,
      onSecondary: Color(0xFF000000),
      surface: _darkSurfaceColor,
      onSurface: Color(0xFFE6E1E5),
      background: _darkBackgroundColor,
      onBackground: Color(0xFFE6E1E5),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      outline: Color(0xFF938F99),
      outlineVariant: Color(0xFF49454F),
    ),
    
    // Typography (same as light theme)
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
        color: const Color(0xFFE6E1E5),
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
        color: const Color(0xFFE6E1E5),
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
        color: const Color(0xFFE6E1E5),
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
        color: const Color(0xFFE6E1E5),
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
        color: const Color(0xFFE6E1E5),
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
        color: const Color(0xFFE6E1E5),
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
        color: const Color(0xFFE6E1E5),
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
        color: const Color(0xFFE6E1E5),
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.10,
        height: 1.43,
        color: const Color(0xFFE6E1E5),
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.50,
        color: const Color(0xFFE6E1E5),
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: const Color(0xFFCAC4D0),
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.40,
        height: 1.33,
        color: const Color(0xFFCAC4D0),
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.10,
        height: 1.43,
        color: const Color(0xFFE6E1E5),
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
        height: 1.33,
        color: const Color(0xFFCAC4D0),
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
        height: 1.45,
        color: const Color(0xFFCAC4D0),
      ),
    ),
    
    // AppBar theme for dark
    appBarTheme: AppBarTheme(
      backgroundColor: _darkSurfaceColor,
      foregroundColor: const Color(0xFFE6E1E5),
      elevation: elevation0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFE6E1E5),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    
    // Card theme for dark
    cardTheme: CardTheme(
      color: _darkSurfaceColor,
      elevation: elevation1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius12),
      ),
      margin: const EdgeInsets.all(spacing8),
    ),
    
    // Elevated button theme for dark
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: const Color(0xFF000000),
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing24,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
        ),
        elevation: elevation1,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    ),
    
    // Outlined button theme for dark
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkPrimaryColor,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing24,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
        ),
        side: const BorderSide(color: _darkPrimaryColor),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    ),
    
    // Text button theme for dark
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkPrimaryColor,
        minimumSize: const Size(88, 44),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing12,
          vertical: spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius20),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10,
        ),
      ),
    ),
    
    // Input decoration theme for dark
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: Color(0xFF938F99)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: Color(0xFF938F99)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: _darkPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius12),
        borderSide: const BorderSide(color: Color(0xFFFFB4AB)),
      ),
      contentPadding: const EdgeInsets.all(spacing16),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFCAC4D0),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF938F99),
      ),
    ),
    
    // Bottom navigation bar theme for dark
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkSurfaceColor,
      selectedItemColor: _darkPrimaryColor,
      unselectedItemColor: Color(0xFF938F99),
      type: BottomNavigationBarType.fixed,
      elevation: elevation3,
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 24),
    ),
    
    // FloatingActionButton theme for dark
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _darkPrimaryColor,
      foregroundColor: Color(0xFF000000),
      elevation: elevation6,
    ),
    
    // SnackBar theme for dark
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF49454F),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFE6E1E5),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    
    // Chip theme for dark
    chipTheme: ChipThemeData(
      backgroundColor: _darkBackgroundColor,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFE6E1E5),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacing12,
        vertical: spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius8),
      ),
    ),
  );

  // Pet-focused semantic colors
  static const petHealthyColor = Color(0xFF2E7D32);
  static const petWarningColor = Color(0xFFED6C02);
  static const petEmergencyColor = Color(0xFFD32F2F);
  static const petVaccinationColor = Color(0xFF1976D2);
  static const petTreatmentColor = Color(0xFF7B1FA2);
  
  // Achievement badge colors
  static const badgeGoldColor = Color(0xFFFFD700);
  static const badgeSilverColor = Color(0xFFC0C0C0);
  static const badgeBronzeColor = Color(0xFFCD7F32);
  
  // Pet breed color palette for avatars
  static const List<Color> petAvatarColors = [
    Color(0xFFE3F2FD), // Light blue
    Color(0xFFF3E5F5), // Light purple
    Color(0xFFE8F5E8), // Light green
    Color(0xFFFFF3E0), // Light orange
    Color(0xFFEDE7F6), // Light indigo
    Color(0xFFE0F2F1), // Light teal
    Color(0xFFFCE4EC), // Light pink
    Color(0xFFF1F8E9), // Light lime
  ];
}

/// Extension for accessing theme tokens easily
extension AppThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
