# 🎨 Squeak Design System Documentation

## Overview

This document outlines the complete design system for the Squeak Flutter application, including Material 3 implementation, custom components, and design principles.

## 🌈 Color System

### Primary Colors
```dart
// Clinical Blue → Purple Theme
static const Color primaryColor = Color(0xFF4E6BFF);
static const Color primaryVariant = Color(0xFF7A57D1);
static const Color secondaryColor = Color(0xFF7A57D1);

// Gradient Definition
LinearGradient primaryGradient = LinearGradient(
  colors: [Color(0xFF4E6BFF), Color(0xFF7A57D1)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

### Neutral Colors
```dart
// Background Colors
static const Color backgroundColor = Color(0xFFF8F9FA);
static const Color surfaceColor = Color(0xFFFFFFFF);
static const Color cardColor = Color(0xFFFFFFFF);

// Text Colors
static const Color textPrimary = Color(0xFF1A1A1A);
static const Color textSecondary = Color(0xFF6C757D);
static const Color textDisabled = Color(0xFF9E9E9E);

// Border Colors
static const Color borderColor = Color(0xFFE0E0E0);
static const Color dividerColor = Color(0xFFEEEEEE);
```

### Semantic Colors
```dart
// Status Colors
static const Color successColor = Color(0xFF28A745);
static const Color warningColor = Color(0xFFFFC107);
static const Color errorColor = Color(0xFFDC3545);
static const Color infoColor = Color(0xFF17A2B8);

// Usage in Components
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary,
    borderRadius: BorderRadius.circular(8),
  ),
)
```

### Color Usage Guidelines

#### Primary Color Usage
- **Main Actions**: Primary buttons, FABs, important CTAs
- **Navigation**: Active navigation items, app bars
- **Branding**: Logo elements, key UI accents
- **Focus States**: Input field focus, selection states

#### Secondary Color Usage
- **Secondary Actions**: Secondary buttons, links
- **Highlights**: Important text highlights, badges
- **Accents**: Decorative elements, icons
- **Notifications**: Warning states, promotional content

## 📝 Typography

### Font System
```dart
// Primary Font Family
fontFamily: GoogleFonts.inter().fontFamily

// Font Weight Scale
FontWeight.w300  // Light
FontWeight.w400  // Regular
FontWeight.w500  // Medium
FontWeight.w600  // SemiBold
FontWeight.w700  // Bold
FontWeight.w800  // ExtraBold
```

### Text Styles
```dart
class FontStyleTheme {
  // Display Styles
  static TextStyle displayLarge(BuildContext context) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: ColorManager.textPrimary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  
  static TextStyle displayMedium(BuildContext context) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: ColorManager.textPrimary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  
  // Heading Styles
  static TextStyle headlineLarge(BuildContext context) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: ColorManager.textPrimary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  
  static TextStyle headlineMedium(BuildContext context) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ColorManager.textPrimary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  
  // Body Styles
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ColorManager.textPrimary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  
  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorManager.textSecondary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  
  // Caption & Labels
  static TextStyle labelLarge(BuildContext context) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorManager.textPrimary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  
  static TextStyle labelSmall(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: ColorManager.textSecondary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
}
```

### Typography Usage
```dart
// Page Title
Text(
  'My Pets',
  style: FontStyleTheme.headlineLarge(context),
)

// Section Header
Text(
  'Recent Appointments',
  style: FontStyleTheme.headlineMedium(context),
)

// Body Text
Text(
  'Your pet profile has been updated successfully.',
  style: FontStyleTheme.bodyLarge(context),
)

// Caption/Helper Text
Text(
  'Last updated 2 minutes ago',
  style: FontStyleTheme.labelSmall(context),
)
```

### Responsive Typography
```dart
static TextStyle responsiveText(BuildContext context, {
  required double fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  final screenSize = MediaQuery.of(context).size;
  final scaleFactor = screenSize.width < 600 ? 0.9 : 1.0;
  
  return TextStyle(
    fontSize: fontSize * scaleFactor,
    fontWeight: fontWeight ?? FontWeight.w400,
    color: color ?? ColorManager.textPrimary,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
}
```

## 🧩 Component Library

### Buttons

#### VcButton (Primary Button)
```dart
class VcButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double borderRadius;
  
  const VcButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 50,
    this.borderRadius = 12,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: backgroundColor == null 
          ? ColorManager.primaryGradient 
          : null,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? ColorManager.primaryColor)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      foregroundColor ?? Colors.white,
                    ),
                  ),
                )
              : child,
          ),
        ),
      ),
    );
  }
}
```

#### Usage Examples
```dart
// Primary Action Button
VcButton(
  onPressed: () => _handleSubmit(),
  child: Text('Save Pet Profile'),
)

// Secondary Button
VcButton(
  onPressed: () => _handleCancel(),
  backgroundColor: Colors.grey[100],
  foregroundColor: ColorManager.textPrimary,
  child: Text('Cancel'),
)

// Loading Button
VcButton(
  onPressed: () => _handleAsync(),
  isLoading: state is LoadingState,
  child: Text('Book Appointment'),
)
```

### Text Fields

#### VcTextField
```dart
class VcTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;
  final VoidCallback? onTap;
  
  const VcTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: FontStyleTheme.labelLarge(context),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          enabled: enabled,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorManager.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorManager.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: ColorManager.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorManager.errorColor),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
```

### Cards

#### VcCard
```dart
class VcCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  
  const VcCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius = 16,
    this.boxShadow,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

### Loading Components

#### VcLoadingIndicator
```dart
class VcLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;
  
  const VcLoadingIndicator({
    super.key,
    this.message,
    this.size = 24.0,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? ColorManager.primaryColor,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: FontStyleTheme.bodyMedium(context),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
```

#### VcShimmerLoading
```dart
class VcShimmerLoading extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  
  const VcShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: child,
    );
  }
}
```

## 📏 Spacing System

### Spacing Scale
```dart
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

// Usage
SizedBox(height: Spacing.md)
EdgeInsets.all(Spacing.lg)
```

### Layout Guidelines
```dart
// Screen Padding
const EdgeInsets screenPadding = EdgeInsets.all(Spacing.md);

// Card Padding
const EdgeInsets cardPadding = EdgeInsets.all(Spacing.md);

// List Item Spacing
const EdgeInsets listItemPadding = EdgeInsets.symmetric(
  horizontal: Spacing.md,
  vertical: Spacing.sm,
);

// Button Spacing
const EdgeInsets buttonPadding = EdgeInsets.symmetric(
  horizontal: Spacing.lg,
  vertical: Spacing.md,
);
```

## 🎯 Icons System

### Icon Usage
```dart
// Material Icons
Icons.pets              // Pet related
Icons.calendar_today     // Appointments
Icons.medical_services   // Medical/Vet
Icons.qr_code           // QR Code
Icons.notifications     // Notifications

// Custom Icons
class CustomIcons {
  static const IconData veterinary = IconData(0xe900, fontFamily: 'CustomIcons');
  static const IconData petProfile = IconData(0xe901, fontFamily: 'CustomIcons');
  static const IconData vaccination = IconData(0xe902, fontFamily: 'CustomIcons');
}
```

### Icon Button Component
```dart
class VcIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final Color? backgroundColor;
  final double? borderRadius;
  
  const VcIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 24,
    this.backgroundColor,
    this.borderRadius,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundColor != null
        ? BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          )
        : null,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color ?? ColorManager.textPrimary,
          size: size,
        ),
      ),
    );
  }
}
```

## 📱 Layout Components

### Screen Template
```dart
class VcScreenTemplate extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? bottomNavigationBar;
  
  const VcScreenTemplate({
    super.key,
    this.title,
    required this.body,
    this.floatingActionButton,
    this.actions,
    this.showBackButton = true,
    this.bottomNavigationBar,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
        ? AppBar(
            title: Text(title!),
            actions: actions,
            automaticallyImplyLeading: showBackButton,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: ColorManager.textPrimary,
          )
        : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
```

### Section Header
```dart
class VcSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  
  const VcSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontStyleTheme.headlineMedium(context),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: FontStyleTheme.bodyMedium(context),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
```

## 🌍 Internationalization Support

### RTL Layout Support
```dart
class VcDirectionalWidget extends StatelessWidget {
  final Widget child;
  
  const VcDirectionalWidget({
    super.key,
    required this.child,
  });
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic() ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
```

### Responsive Text Direction
```dart
EdgeInsets responsivePadding() {
  return isArabic() 
    ? const EdgeInsets.only(right: 16, left: 8)
    : const EdgeInsets.only(left: 16, right: 8);
}

Alignment responsiveAlignment() {
  return isArabic() ? Alignment.centerRight : Alignment.centerLeft;
}
```

## 🎨 Animation System

### Transition Animations
```dart
class VcPageTransition extends PageRouteBuilder {
  final Widget child;
  
  VcPageTransition({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
}
```

### Micro-Interactions
```dart
class VcAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  
  const VcAnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
  });
  
  @override
  State<VcAnimatedButton> createState() => _VcAnimatedButtonState();
}

class _VcAnimatedButtonState extends State<VcAnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## 📏 Design Tokens

### Border Radius
```dart
class BorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 24.0;
  static const double circular = 50.0;
}
```

### Elevation/Shadows
```dart
class Elevation {
  static List<BoxShadow> level1 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];
  
  static List<BoxShadow> level2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> level3 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
```

## 🎯 Usage Guidelines

### When to Use Each Component

#### Buttons
- **VcButton**: Primary actions, form submissions
- **TextButton**: Secondary actions, navigation
- **IconButton**: Tool actions, app bar actions

#### Text Fields
- **VcTextField**: All form inputs
- **SearchField**: Search functionality
- **TextArea**: Multi-line input

#### Cards
- **VcCard**: Content grouping, list items
- **InfoCard**: Status displays, summaries
- **ActionCard**: Interactive content blocks

### Design Principles

#### Consistency
- Use design tokens consistently
- Follow established patterns
- Maintain visual hierarchy

#### Accessibility
- Ensure sufficient color contrast
- Support screen readers
- Provide touch targets ≥44px

#### Performance
- Optimize images and animations
- Use efficient layouts
- Minimize widget rebuilds

---

This design system ensures a consistent, accessible, and beautiful user experience throughout the Squeak application.
