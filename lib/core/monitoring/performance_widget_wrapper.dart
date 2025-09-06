import 'package:flutter/material.dart';
import 'package:squeak/core/monitoring/advanced_performance_monitor.dart';

/// Widget wrapper that monitors build performance
class PerformanceMonitoredWidget extends StatelessWidget {
  final Widget child;
  final String widgetName;
  
  const PerformanceMonitoredWidget({
    super.key,
    required this.child,
    required this.widgetName,
  });

  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    // Build the child widget
    final builtChild = child;
    
    stopwatch.stop();
    
    // Track build performance
    AdvancedPerformanceMonitor().trackWidgetBuild(
      widgetName,
      stopwatch.elapsedMilliseconds,
    );
    
    return builtChild;
  }
}

/// Mixin for monitoring widget builds
mixin PerformanceMonitorMixin<T extends StatefulWidget> on State<T> {
  late String _widgetName;

  @override
  void initState() {
    super.initState();
    _widgetName = runtimeType.toString();
  }

  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    final widget = buildMonitored(context);
    
    stopwatch.stop();
    AdvancedPerformanceMonitor().trackWidgetBuild(
      _widgetName,
      stopwatch.elapsedMilliseconds,
    );
    
    return widget;
  }

  /// Override this method instead of build()
  Widget buildMonitored(BuildContext context);
}
