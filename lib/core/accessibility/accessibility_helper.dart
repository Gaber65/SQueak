import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities and helpers for the app
class AccessibilityHelper {
  /// Announce text to screen readers
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Announce with custom text direction
  static void announceWithDirection(
    BuildContext context, 
    String message, 
    TextDirection direction,
  ) {
    SemanticsService.announce(message, direction);
  }

  /// Check if screen reader is enabled
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  /// Check if reduce motion is enabled
  static bool isReduceMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Check if high contrast is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  /// Get appropriate animation duration based on accessibility settings
  static Duration getAnimationDuration(
    BuildContext context, {
    Duration defaultDuration = const Duration(milliseconds: 300),
    Duration reducedDuration = const Duration(milliseconds: 100),
  }) {
    return isReduceMotionEnabled(context) ? reducedDuration : defaultDuration;
  }

  /// Create semantic wrapper with comprehensive accessibility
  static Widget semanticWrapper({
    required Widget child,
    String? label,
    String? hint,
    String? value,
    String? increasedValue,
    String? decreasedValue,
    bool? enabled,
    bool? checked,
    bool? selected,
    bool? button,
    bool? link,
    bool? header,
    bool? textField,
    bool? readOnly,
    bool? focusable,
    bool? focused,
    bool? inMutuallyExclusiveGroup,
    bool? obscured,
    bool? multiline,
    bool? hidden,
    bool? image,
    bool? liveRegion,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onScrollLeft,
    VoidCallback? onScrollRight,
    VoidCallback? onScrollUp,
    VoidCallback? onScrollDown,
    VoidCallback? onIncrease,
    VoidCallback? onDecrease,
    VoidCallback? onCopy,
    VoidCallback? onCut,
    VoidCallback? onPaste,
    VoidCallback? onDismiss,
    VoidCallback? onDidGainAccessibilityFocus,
    VoidCallback? onDidLoseAccessibilityFocus,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      increasedValue: increasedValue,
      decreasedValue: decreasedValue,
      enabled: enabled,
      checked: checked,
      selected: selected,
      button: button,
      link: link,
      header: header,
      textField: textField,
      readOnly: readOnly,
      focusable: focusable,
      focused: focused,
      inMutuallyExclusiveGroup: inMutuallyExclusiveGroup,
      obscured: obscured,
      multiline: multiline,
      hidden: hidden,
      image: image,
      liveRegion: liveRegion,
      onTap: onTap,
      onLongPress: onLongPress,
      onScrollLeft: onScrollLeft,
      onScrollRight: onScrollRight,
      onScrollUp: onScrollUp,
      onScrollDown: onScrollDown,
      onIncrease: onIncrease,
      onDecrease: onDecrease,
      onCopy: onCopy,
      onCut: onCut,
      onPaste: onPaste,
      onDismiss: onDismiss,
      onDidGainAccessibilityFocus: onDidGainAccessibilityFocus,
      onDidLoseAccessibilityFocus: onDidLoseAccessibilityFocus,
      child: child,
    );
  }

  /// Create focus wrapper for keyboard navigation
  static Widget focusWrapper({
    required Widget child,
    FocusNode? focusNode,
    bool autofocus = false,
    VoidCallback? onFocusChange,
    bool canRequestFocus = true,
    bool skipTraversal = false,
    bool descendantsAreFocusable = true,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      canRequestFocus: canRequestFocus,
      skipTraversal: skipTraversal,
      descendantsAreFocusable: descendantsAreFocusable,
      onFocusChange: onFocusChange != null 
        ? (focused) => onFocusChange() 
        : null,
      child: child,
    );
  }

  /// Create high contrast color scheme
  static ColorScheme createHighContrastColorScheme(ColorScheme baseScheme) {
    return baseScheme.copyWith(
      primary: baseScheme.brightness == Brightness.light 
        ? Colors.black 
        : Colors.white,
      onPrimary: baseScheme.brightness == Brightness.light 
        ? Colors.white 
        : Colors.black,
      secondary: baseScheme.brightness == Brightness.light 
        ? Colors.black87 
        : Colors.white70,
      onSecondary: baseScheme.brightness == Brightness.light 
        ? Colors.white 
        : Colors.black,
      surface: baseScheme.brightness == Brightness.light 
        ? Colors.white 
        : Colors.black,
      onSurface: baseScheme.brightness == Brightness.light 
        ? Colors.black 
        : Colors.white,
      outline: baseScheme.brightness == Brightness.light 
        ? Colors.black54 
        : Colors.white54,
    );
  }

  /// Get minimum touch target size
  static Size getMinimumTouchTarget() {
    return const Size(48.0, 48.0); // Material Design recommendation
  }

  /// Ensure widget meets minimum touch target size
  static Widget ensureMinimumTouchTarget({
    required Widget child,
    Size? minimumSize,
  }) {
    final size = minimumSize ?? getMinimumTouchTarget();
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: size.width,
        minHeight: size.height,
      ),
      child: child,
    );
  }

  /// Create accessible loading indicator
  static Widget accessibleLoadingIndicator({
    String? semanticLabel,
    double? size,
    Color? color,
    double strokeWidth = 4.0,
  }) {
    return Semantics(
      label: semanticLabel ?? 'Loading',
      liveRegion: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }

  /// Create accessible error message
  static Widget accessibleErrorMessage({
    required String message,
    IconData? icon,
    Color? color,
    VoidCallback? onRetry,
    String? retryLabel,
  }) {
    return Semantics(
      label: 'Error: $message',
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: color ?? Colors.red,
              semanticLabel: 'Error icon',
            ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: color ?? Colors.red),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryLabel ?? 'Retry'),
            ),
          ],
        ],
      ),
    );
  }

  /// Create accessible success message
  static Widget accessibleSuccessMessage({
    required String message,
    IconData? icon,
    Color? color,
    Duration? displayDuration,
  }) {
    return Semantics(
      label: 'Success: $message',
      liveRegion: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: color ?? Colors.green,
              semanticLabel: 'Success icon',
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              message,
              style: TextStyle(color: color ?? Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  /// Create accessible form field with comprehensive labels
  static Widget accessibleFormField({
    required Widget child,
    String? label,
    String? hint,
    String? errorText,
    bool required = false,
  }) {
    String? combinedLabel = label;
    if (required && label != null) {
      combinedLabel = '$label (required)';
    }

    return Semantics(
      label: combinedLabel,
      hint: hint,
      textField: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              required ? '$label *' : label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          if (label != null) const SizedBox(height: 8),
          child,
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(
              hint,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          if (errorText != null) ...[
            const SizedBox(height: 4),
            Semantics(
              liveRegion: true,
              child: Text(
                errorText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Accessibility configuration for the app
class AccessibilityConfig {
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration reducedAnimationDuration = Duration(milliseconds: 100);
  static const Duration noAnimationDuration = Duration.zero;
  
  static const Size minimumTouchTarget = Size(48.0, 48.0);
  static const double minimumFontSize = 14.0;
  static const double largeFontSize = 18.0;
  
  static const EdgeInsets minimumPadding = EdgeInsets.all(8.0);
  static const EdgeInsets largePadding = EdgeInsets.all(16.0);
}

/// Mixin for widgets that need accessibility support
mixin AccessibilityMixin<T extends StatefulWidget> on State<T> {
  /// Check if reduce motion is enabled
  bool get isReduceMotionEnabled => 
      MediaQuery.of(context).disableAnimations;

  /// Check if screen reader is enabled
  bool get isScreenReaderEnabled => 
      MediaQuery.of(context).accessibleNavigation;

  /// Check if high contrast is enabled
  bool get isHighContrastEnabled => 
      MediaQuery.of(context).highContrast;

  /// Get appropriate animation duration
  Duration getAnimationDuration({
    Duration? defaultDuration,
    Duration? reducedDuration,
  }) {
    if (isReduceMotionEnabled) {
      return reducedDuration ?? AccessibilityConfig.reducedAnimationDuration;
    }
    return defaultDuration ?? AccessibilityConfig.defaultAnimationDuration;
  }

  /// Announce to screen readers
  void announce(String message) {
    AccessibilityHelper.announce(context, message);
  }
}
