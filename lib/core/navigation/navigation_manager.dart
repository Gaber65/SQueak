import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enhanced navigation system with deep linking and state management
class NavigationManager {
  static final NavigationManager _instance = NavigationManager._internal();
  factory NavigationManager() => _instance;
  NavigationManager._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final List<String> _navigationHistory = [];
  String? _currentRoute;
  Map<String, dynamic>? _currentRouteArgs;

  /// Get current navigation context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Get current route name
  String? get currentRoute => _currentRoute;

  /// Get current route arguments
  Map<String, dynamic>? get currentRouteArgs => _currentRouteArgs;

  /// Get navigation history
  List<String> get navigationHistory => List.unmodifiable(_navigationHistory);

  /// Navigate to a route with enhanced tracking
  Future<T?> navigateTo<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool clearHistory = false,
    bool addToHistory = true,
    Duration? transitionDuration,
    Curve transitionCurve = Curves.easeInOut,
  }) async {
    final context = currentContext;
    if (context == null) return null;

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Clear history if requested
    if (clearHistory) {
      _navigationHistory.clear();
    }

    // Add to history
    if (addToHistory && _currentRoute != null) {
      _navigationHistory.add(_currentRoute!);
    }

    // Update current route tracking
    _currentRoute = routeName;
    _currentRouteArgs = arguments as Map<String, dynamic>?;

    // Custom page route with enhanced transitions
    if (transitionDuration != null) {
      return Navigator.of(context).push<T>(
        PageRouteBuilder<T>(
          pageBuilder: (context, animation, secondaryAnimation) {
            return _buildRouteWidget(routeName, arguments);
          },
          transitionDuration: transitionDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: transitionCurve,
              )),
              child: child,
            );
          },
        ),
      );
    }

    // Standard navigation
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// Navigate and replace current route
  Future<T?> navigateAndReplace<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) async {
    final context = currentContext;
    if (context == null) return null;

    HapticFeedback.lightImpact();

    _currentRoute = routeName;
    _currentRouteArgs = arguments as Map<String, dynamic>?;

    return Navigator.of(context).pushReplacementNamed(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate back with enhanced tracking
  void navigateBack<T extends Object?>([T? result]) {
    final context = currentContext;
    if (context == null) return;

    HapticFeedback.lightImpact();

    // Update current route from history
    if (_navigationHistory.isNotEmpty) {
      _currentRoute = _navigationHistory.removeLast();
    }

    Navigator.of(context).pop(result);
  }

  /// Navigate back to specific route
  void navigateBackTo(String routeName) {
    final context = currentContext;
    if (context == null) return;

    HapticFeedback.lightImpact();

    Navigator.of(context).popUntil((route) {
      return route.settings.name == routeName;
    });

    // Update tracking
    _currentRoute = routeName;
    _navigationHistory.removeWhere((route) => route == routeName);
  }

  /// Clear navigation stack and go to route
  Future<T?> clearAndNavigateTo<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    final context = currentContext;
    if (context == null) return null;

    HapticFeedback.lightImpact();

    _navigationHistory.clear();
    _currentRoute = routeName;
    _currentRouteArgs = arguments as Map<String, dynamic>?;

    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Show modal bottom sheet with enhanced design
  Future<T?> showEnhancedBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isDismissible = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) async {
    final context = currentContext;
    if (context == null) return null;

    HapticFeedback.lightImpact();

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape ?? const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isDismissible: isDismissible,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      builder: (context) => child,
    );
  }

  /// Show enhanced dialog
  Future<T?> showEnhancedDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) async {
    final context = currentContext;
    if (context == null) return null;

    HapticFeedback.lightImpact();

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      builder: (context) => child,
    );
  }

  /// Build widget for route
  Widget _buildRouteWidget(String routeName, Object? arguments) {
    // This would integrate with your route configuration
    // For now, return a placeholder
    return Scaffold(
      appBar: AppBar(title: Text(routeName)),
      body: Center(
        child: Text('Route: $routeName'),
      ),
    );
  }
}

/// Enhanced snackbar system with consistent design
class SnackBarManager {
  static final SnackBarManager _instance = SnackBarManager._internal();
  factory SnackBarManager() => _instance;
  SnackBarManager._internal();

  /// Show success snackbar
  void showSuccess({
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show error snackbar
  void showError({
    required String message,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show warning snackbar
  void showWarning({
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show info snackbar
  void showInfo({
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Show custom snackbar
  void showCustom({
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    _showSnackBar(
      message: message,
      backgroundColor: backgroundColor,
      icon: icon,
      duration: duration,
      onAction: onAction,
      actionLabel: actionLabel,
    );
  }

  /// Internal method to show snackbar
  void _showSnackBar({
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final context = NavigationManager().currentContext;
    if (context == null) return;

    HapticFeedback.lightImpact();

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      action: onAction != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onAction,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Loading overlay manager
class LoadingManager {
  static final LoadingManager _instance = LoadingManager._internal();
  factory LoadingManager() => _instance;
  LoadingManager._internal();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  /// Show loading overlay
  void show({
    String? message,
    bool barrierDismissible = false,
  }) {
    if (_isShowing) return;

    final context = NavigationManager().currentContext;
    if (context == null) return;

    _isShowing = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => LoadingOverlay(
        message: message,
        barrierDismissible: barrierDismissible,
        onDismiss: hide,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide loading overlay
  void hide() {
    if (!_isShowing) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    _isShowing = false;
  }

  /// Check if loading is currently showing
  bool get isShowing => _isShowing;
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
    this.barrierDismissible = false,
    this.onDismiss,
  });

  final String? message;
  final bool barrierDismissible;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: GestureDetector(
        onTap: barrierDismissible ? onDismiss : null,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
