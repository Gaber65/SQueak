// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced button with accessibility, haptic feedback, and loading states
class VCEnhancedButton extends StatefulWidget {
  const VCEnhancedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.style,
    this.autofocus = false,
    this.focusNode,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.semanticLabel,
    this.tooltip,
    this.isLoading = false,
    this.loadingText,
    this.hapticFeedback = true,
    this.debounceTime = const Duration(milliseconds: 300),
    this.elevation,
    this.shadowColor,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final bool autofocus;
  final FocusNode? focusNode;
  final Clip clipBehavior;
  final WidgetStatesController? statesController;
  final String? semanticLabel;
  final String? tooltip;
  final bool isLoading;
  final String? loadingText;
  final bool hapticFeedback;
  final Duration debounceTime;
  final double? elevation;
  final Color? shadowColor;
  final Duration animationDuration;

  @override
  State<VCEnhancedButton> createState() => _VCEnhancedButtonState();
}

class _VCEnhancedButtonState extends State<VCEnhancedButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  DateTime? _lastPressed;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
      
      if (widget.hapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  void _handleTapEnd() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _handlePressed() {
    if (widget.onPressed == null || widget.isLoading) return;

    final now = DateTime.now();
    if (_lastPressed != null && 
        now.difference(_lastPressed!) < widget.debounceTime) {
      return; // Debounce the press
    }
    
    _lastPressed = now;
    
    if (widget.hapticFeedback) {
      HapticFeedback.mediumImpact();
    }
    
    widget.onPressed!();
  }

  void _handleLongPressed() {
    if (widget.onLongPress == null || widget.isLoading) return;
    
    if (widget.hapticFeedback) {
      HapticFeedback.heavyImpact();
    }
    
    widget.onLongPress!();
  }

  ButtonStyle _getEnhancedStyle() {
    final baseStyle = widget.style ?? ElevatedButton.styleFrom();
    
    return baseStyle.copyWith(
      elevation: MaterialStateProperty.resolveWith<double?>((states) {
        if (widget.elevation != null) {
          return widget.elevation;
        }
        if (states.contains(MaterialState.pressed)) {
          return 2.0;
        }
        if (states.contains(MaterialState.hovered)) {
          return 8.0;
        }
        return 4.0;
      }),
      shadowColor: MaterialStateProperty.all(widget.shadowColor),
      animationDuration: widget.animationDuration,
    );
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        if (widget.loadingText != null) ...[
          const SizedBox(width: 8),
          Text(
            widget.loadingText!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return _buildLoadingIndicator();
    }
    return widget.child;
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : _handlePressed,
          onLongPress: widget.isLoading ? null : _handleLongPressed,
          style: _getEnhancedStyle(),
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          clipBehavior: widget.clipBehavior,
          statesController: widget.statesController,
          child: AnimatedSwitcher(
            duration: widget.animationDuration,
            child: _buildContent(),
          ),
        ),
      ),
    );

    // Add semantic label if provided
    if (widget.semanticLabel != null) {
      button = Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: widget.onPressed != null && !widget.isLoading,
        child: button,
      );
    }

    // Add tooltip if provided
    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Enhanced icon button with accessibility and haptic feedback
class VCEnhancedIconButton extends StatefulWidget {
  const VCEnhancedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.color,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.disabledColor,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback = true,
    this.constraints,
    this.style,
    this.isSelected = false,
    this.selectedIcon,
    this.semanticLabel,
    this.hapticFeedback = true,
    this.debounceTime = const Duration(milliseconds: 300),
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final double? splashRadius;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? disabledColor;
  final MouseCursor? mouseCursor;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? tooltip;
  final bool enableFeedback;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  final bool isSelected;
  final Widget? selectedIcon;
  final String? semanticLabel;
  final bool hapticFeedback;
  final Duration debounceTime;
  final Duration animationDuration;

  @override
  State<VCEnhancedIconButton> createState() => _VCEnhancedIconButtonState();
}

class _VCEnhancedIconButtonState extends State<VCEnhancedIconButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  DateTime? _lastPressed;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePressed() {
    if (widget.onPressed == null) return;

    final now = DateTime.now();
    if (_lastPressed != null && 
        now.difference(_lastPressed!) < widget.debounceTime) {
      return;
    }
    
    _lastPressed = now;
    
    // Animate press
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
    
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    Widget iconButton = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: IconButton(
        onPressed: _handlePressed,
        icon: widget.isSelected && widget.selectedIcon != null 
            ? widget.selectedIcon! 
            : widget.icon,
        iconSize: widget.iconSize,
        visualDensity: widget.visualDensity,
        padding: widget.padding,
        alignment: widget.alignment,
        splashRadius: widget.splashRadius,
        color: widget.color,
        focusColor: widget.focusColor,
        hoverColor: widget.hoverColor,
        highlightColor: widget.highlightColor,
        splashColor: widget.splashColor,
        disabledColor: widget.disabledColor,
        mouseCursor: widget.mouseCursor,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        tooltip: widget.tooltip,
        enableFeedback: widget.enableFeedback,
        constraints: widget.constraints,
        style: widget.style,
        isSelected: widget.isSelected,
        selectedIcon: widget.selectedIcon,
      ),
    );

    // Add semantic label if provided
    if (widget.semanticLabel != null) {
      iconButton = Semantics(
        label: widget.semanticLabel,
        button: true,
        enabled: widget.onPressed != null,
        child: iconButton,
      );
    }

    return iconButton;
  }
}
