import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance utilities for better app performance
class PerformanceUtils {
  /// Debounce utility for search inputs and API calls
  static Timer? _debounceTimer;
  
  static void debounce({
    required VoidCallback callback,
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  /// Cancel any active debounce timer
  static void cancelDebounce() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  /// Throttle utility for scroll events
  static DateTime? _lastThrottleTime;
  
  static void throttle({
    required VoidCallback callback,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    final now = DateTime.now();
    if (_lastThrottleTime == null || 
        now.difference(_lastThrottleTime!) >= delay) {
      _lastThrottleTime = now;
      callback();
    }
  }

  /// Execute heavy computations in isolate
  static Future<T> computeInIsolate<T>(
    ComputeCallback<dynamic, T> callback,
    dynamic message,
  ) async {
    return compute(callback, message);
  }

  /// Post frame callback for defer operations
  static void postFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

  /// Memory-efficient image cache configuration
  static const int maxImageCacheSize = 100; // MB
  static const int maxImageCacheCount = 1000;

  /// Configure image cache for better performance
  static void configureImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = maxImageCacheCount;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 
        maxImageCacheSize * 1024 * 1024;
  }
}

/// Mixin for performance-optimized widgets
mixin PerformanceOptimizedWidgetMixin<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;

  void debouncedCall(VoidCallback callback, [Duration? delay]) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      delay ?? const Duration(milliseconds: 300),
      callback,
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Performance-optimized list view builder
class PerformantListView extends StatelessWidget {
  const PerformantListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey('performant_list_view'),
      controller: controller,
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: cacheExtent ?? 250.0, // Optimized cache extent
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: ValueKey('list_item_$index'),
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Performance-optimized grid view builder  
class PerformantGridView extends StatelessWidget {
  const PerformantGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.cacheExtent,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double? cacheExtent;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const PageStorageKey('performant_grid_view'),
      controller: controller,
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      shrinkWrap: shrinkWrap,
      physics: physics,
      cacheExtent: cacheExtent ?? 250.0,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          key: ValueKey('grid_item_$index'),
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Performance metrics tracker (development only)
class PerformanceTracker {
  static final Map<String, Stopwatch> _stopwatches = {};
  
  static void startTracking(String operation) {
    if (kDebugMode) {
      _stopwatches[operation] = Stopwatch()..start();
    }
  }
  
  static void endTracking(String operation) {
    if (kDebugMode && _stopwatches.containsKey(operation)) {
      final stopwatch = _stopwatches[operation]!;
      stopwatch.stop();
      debugPrint('Performance: $operation took ${stopwatch.elapsedMilliseconds}ms');
      _stopwatches.remove(operation);
    }
  }
  
  static void trackWidgetBuild(String widgetName, VoidCallback buildFunction) {
    if (kDebugMode) {
      startTracking('build_$widgetName');
      buildFunction();
      endTracking('build_$widgetName');
    } else {
      buildFunction();
    }
  }
}
