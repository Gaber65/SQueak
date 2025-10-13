// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../app_theme.dart';

/// Modern Material 3 button component for Squeak app
class VcButton extends StatelessWidget {
  const VcButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = VcButtonVariant.elevated,
    this.size = VcButtonSize.medium,
    this.width,
    this.isLoading = false,
    this.icon,
    this.suffixIcon,
    this.color,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final VcButtonVariant variant;
  final VcButtonSize size;
  final double? width;
  final bool isLoading;
  final Widget? icon;
  final Widget? suffixIcon;
  final Color? color;

  /// Factory for primary elevated button
  factory VcButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VcButtonSize size = VcButtonSize.medium,
    double? width,
    bool isLoading = false,
    Widget? icon,
    Widget? suffixIcon,
  }) {
    return VcButton(
      key: key,
      onPressed: onPressed,
      variant: VcButtonVariant.elevated,
      size: size,
      width: width,
      isLoading: isLoading,
      icon: icon,
      suffixIcon: suffixIcon,
      child: child,
    );
  }

  /// Factory for secondary outlined button
  factory VcButton.secondary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VcButtonSize size = VcButtonSize.medium,
    double? width,
    bool isLoading = false,
    Widget? icon,
    Widget? suffixIcon,
  }) {
    return VcButton(
      key: key,
      onPressed: onPressed,
      variant: VcButtonVariant.outlined,
      size: size,
      width: width,
      isLoading: isLoading,
      icon: icon,
      suffixIcon: suffixIcon,
      child: child,
    );
  }

  /// Factory for text button
  factory VcButton.text({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VcButtonSize size = VcButtonSize.medium,
    double? width,
    bool isLoading = false,
    Widget? icon,
    Widget? suffixIcon,
  }) {
    return VcButton(
      key: key,
      onPressed: onPressed,
      variant: VcButtonVariant.text,
      size: size,
      width: width,
      isLoading: isLoading,
      icon: icon,
      suffixIcon: suffixIcon,
      child: child,
    );
  }

  /// Factory for destructive action button
  factory VcButton.destructive({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VcButtonSize size = VcButtonSize.medium,
    double? width,
    bool isLoading = false,
    Widget? icon,
    Widget? suffixIcon,
  }) {
    return VcButton(
      key: key,
      onPressed: onPressed,
      variant: VcButtonVariant.destructive,
      size: size,
      width: width,
      isLoading: isLoading,
      icon: icon,
      suffixIcon: suffixIcon,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;
    
    final buttonSize = _getButtonSize(size);
    final buttonStyle = _getButtonStyle(variant, theme, buttonSize);
    
    Widget content = _buildContent(theme);

    Widget button;
    switch (variant) {
      case VcButtonVariant.elevated:
      case VcButtonVariant.destructive:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: content,
        );
        break;
      case VcButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: content,
        );
        break;
      case VcButtonVariant.text:
        button = TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: buttonStyle,
          child: content,
        );
        break;
    }

    if (width != null) {
      button = SizedBox(width: width, child: button);
    }

    return button;
  }

  Widget _buildContent(ThemeData theme) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == VcButtonVariant.elevated || variant == VcButtonVariant.destructive
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppTheme.spacing8),
          child,
        ],
      );
    }

    if (icon != null || suffixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppTheme.spacing8),
          ],
          child,
          if (suffixIcon != null) ...[
            const SizedBox(width: AppTheme.spacing8),
            suffixIcon!,
          ],
        ],
      );
    }

    return child;
  }

  ButtonStyle _getButtonStyle(VcButtonVariant variant, ThemeData theme, _ButtonSize buttonSize) {
    final baseStyle = ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size(buttonSize.minWidth, buttonSize.height)),
      padding: WidgetStateProperty.all(buttonSize.padding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius20),
        ),
      ),
      textStyle: WidgetStateProperty.all(buttonSize.textStyle),
    );

    switch (variant) {
      case VcButtonVariant.elevated:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (color != null) return color;
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withOpacity(0.12);
            }
            return theme.colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withOpacity(0.38);
            }
            return theme.colorScheme.onPrimary;
          }),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.pressed)) return 6;
            return 1;
          }),
        );
        
      case VcButtonVariant.outlined:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (color != null) return color;
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withOpacity(0.38);
            }
            return theme.colorScheme.primary;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12));
            }
            return BorderSide(color: color ?? theme.colorScheme.primary);
          }),
        );
        
      case VcButtonVariant.text:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (color != null) return color;
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withOpacity(0.38);
            }
            return theme.colorScheme.primary;
          }),
          overlayColor: WidgetStateProperty.all(
            (color ?? theme.colorScheme.primary).withOpacity(0.08),
          ),
        );
        
      case VcButtonVariant.destructive:
        return baseStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withOpacity(0.12);
            }
            return theme.colorScheme.error;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.onSurface.withOpacity(0.38);
            }
            return theme.colorScheme.onError;
          }),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.pressed)) return 6;
            return 1;
          }),
        );
    }
  }

  _ButtonSize _getButtonSize(VcButtonSize size) {
    switch (size) {
      case VcButtonSize.small:
        return _ButtonSize(
          height: 32,
          minWidth: 64,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing16,
            vertical: AppTheme.spacing8,
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        );
      case VcButtonSize.medium:
        return _ButtonSize(
          height: 44,
          minWidth: 88,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing24,
            vertical: AppTheme.spacing12,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        );
      case VcButtonSize.large:
        return _ButtonSize(
          height: 56,
          minWidth: 120,
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing32,
            vertical: AppTheme.spacing16,
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        );
    }
  }
}

/// Button size variants
enum VcButtonSize { small, medium, large }

/// Button style variants
enum VcButtonVariant { elevated, outlined, text, destructive }

/// Internal button size configuration
class _ButtonSize {
  const _ButtonSize({
    required this.height,
    required this.minWidth,
    required this.padding,
    required this.textStyle,
  });

  final double height;
  final double minWidth;
  final EdgeInsets padding;
  final TextStyle textStyle;
}
