import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Advanced performance monitoring and optimization system
class AdvancedPerformanceMonitor {
  static final AdvancedPerformanceMonitor _instance = AdvancedPerformanceMonitor._internal();
  factory AdvancedPerformanceMonitor() => _instance;
  AdvancedPerformanceMonitor._internal();

  final Map<String, Stopwatch> _activeOperations = {};
  final List<PerformanceMetric> _metrics = [];
  final List<MemorySnapshot> _memorySnapshots = [];
  Timer? _memoryMonitorTimer;
  Timer? _reportingTimer;
  
  Duration _lastFrameTime = Duration.zero;
  int _frameCount = 0;
  double _averageFPS = 60.0;
  bool _isInitialized = false;

  /// Initialize the performance monitor
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _startMemoryMonitoring();
    _startFrameRateMonitoring();
    _startPerformanceReporting();
    _isInitialized = true;
    
    if (kDebugMode) {
      debugPrint('Advanced Performance Monitor initialized');
    }
  }

  /// Start monitoring memory usage
  void _startMemoryMonitoring() {
    _memoryMonitorTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _recordMemorySnapshot();
    });
  }

  /// Start monitoring frame rate
  void _startFrameRateMonitoring() {
    SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);
  }

  /// Start performance reporting
  void _startPerformanceReporting() {
    _reportingTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _generatePerformanceReport();
    });
  }

  /// Frame callback for monitoring FPS
  void _onFrame(Duration timestamp) {
    if (_lastFrameTime != Duration.zero) {
      final frameDuration = timestamp - _lastFrameTime;
      if (frameDuration.inMicroseconds > 0) {
        final fps = 1000000 / frameDuration.inMicroseconds;
        
        _frameCount++;
        _averageFPS = (_averageFPS * (_frameCount - 1) + fps) / _frameCount;
        
        // Reset counter periodically to prevent overflow
        if (_frameCount > 1000) {
          _frameCount = 100;
        }
      }
    }
    _lastFrameTime = timestamp;
    
    SchedulerBinding.instance.addPersistentFrameCallback(_onFrame);
  }

  /// Record exception for error tracking
  void recordException(Object exception, StackTrace? stackTrace) {
    final errorMetric = PerformanceMetric(
      name: 'exception',
      value: 1.0,
      timestamp: DateTime.now(),
      metadata: {
        'exception': exception.toString(),
        'stackTrace': stackTrace?.toString(),
      },
    );
    
    _addMetric(errorMetric);
    
    if (kDebugMode) {
      debugPrint('ERROR: Exception recorded: $exception');
    }
  }

  /// Start tracking an operation
  void startOperation(String operationName) {
    final stopwatch = Stopwatch()..start();
    _activeOperations[operationName] = stopwatch;
    
    if (kDebugMode) {
      debugPrint('Started operation: $operationName');
    }
  }

  /// End tracking an operation
  void endOperation(String operationName, {Map<String, dynamic>? metadata}) {
    final stopwatch = _activeOperations.remove(operationName);
    if (stopwatch != null) {
      stopwatch.stop();
      
      final metric = PerformanceMetric(
        name: operationName,
        value: stopwatch.elapsedMilliseconds.toDouble(),
        timestamp: DateTime.now(),
        metadata: metadata,
      );
      
      _addMetric(metric);
      
      if (kDebugMode) {
        debugPrint('SUCCESS: Completed operation: $operationName (${stopwatch.elapsedMilliseconds}ms)');
      }
      
      // Alert for slow operations
      if (stopwatch.elapsedMilliseconds > 1000) {
        if (kDebugMode) {
          debugPrint('WARNING: Slow operation detected: $operationName took ${stopwatch.elapsedMilliseconds}ms');
        }
      }
    }
  }

  /// Track network request performance
  void trackNetworkRequest(String endpoint, int duration, {int? statusCode, String? error}) {
    final metric = PerformanceMetric(
      name: 'network_request',
      value: duration.toDouble(),
      timestamp: DateTime.now(),
      metadata: {
        'endpoint': endpoint,
        'statusCode': statusCode,
        'error': error,
      },
    );
    
    _addMetric(metric);
    
    if (kDebugMode) {
      debugPrint('Network request: $endpoint (${duration}ms)');
    }
  }

  /// Track widget build performance
  void trackWidgetBuild(String widgetName, int buildTimeMs) {
    final metric = PerformanceMetric(
      name: 'widget_build',
      value: buildTimeMs.toDouble(),
      timestamp: DateTime.now(),
      metadata: {
        'widget': widgetName,
      },
    );
    
    _addMetric(metric);
    
    if (buildTimeMs > 16) { // Frame budget exceeded
      if (kDebugMode) {
        debugPrint('WARNING: Slow widget build: $widgetName took ${buildTimeMs}ms');
      }
    }
  }

  /// Get current performance metrics
  PerformanceReport getCurrentMetrics() {
    return PerformanceReport(
      averageFPS: _averageFPS,
      memoryUsage: _memorySnapshots.isNotEmpty ? _memorySnapshots.last.usedMemoryMB : 0.0,
      recentMetrics: _metrics.take(100).toList(),
      activeOperations: _activeOperations.keys.toList(),
    );
  }

  /// Record memory snapshot
  Future<void> _recordMemorySnapshot() async {
    try {
      // Basic memory estimation
      double memoryUsage = _estimateMemoryUsage();
      
      final snapshot = MemorySnapshot(
        timestamp: DateTime.now(),
        usedMemoryMB: memoryUsage,
      );
      
      _memorySnapshots.add(snapshot);
      
      // Keep only recent snapshots
      if (_memorySnapshots.length > 100) {
        _memorySnapshots.removeAt(0);
      }
      
      if (kDebugMode) {
        debugPrint('Memory usage: ${memoryUsage.toStringAsFixed(1)}MB');
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Failed to record memory snapshot: $e');
      }
    }
  }

  /// Estimate memory usage (fallback method)
  double _estimateMemoryUsage() {
    // Basic estimation based on metrics count and cached data
    final baseMemory = 50.0; // App base memory
    final metricsMemory = _metrics.length * 0.001; // Rough estimate
    return baseMemory + metricsMemory;
  }

  /// Add a performance metric
  void _addMetric(PerformanceMetric metric) {
    _metrics.add(metric);
    
    // Keep only recent metrics to prevent memory leaks
    if (_metrics.length > 1000) {
      _metrics.removeRange(0, 500); // Remove oldest 500 metrics
    }
  }

  /// Generate performance report
  void _generatePerformanceReport() {
    final report = getCurrentMetrics();
    
    if (kDebugMode) {
      debugPrint('Performance Report:');
      debugPrint('   FPS: ${report.averageFPS.toStringAsFixed(1)}');
      debugPrint('   Memory: ${report.memoryUsage.toStringAsFixed(1)}MB');
      debugPrint('   Active Operations: ${report.activeOperations.length}');
      debugPrint('   Recent Metrics: ${report.recentMetrics.length}');
    }
    
    // Check for performance issues
    if (report.averageFPS < 45) {
      if (kDebugMode) {
        debugPrint('WARNING: Low FPS detected: ${report.averageFPS.toStringAsFixed(1)}');
      }
    }
    
    if (report.memoryUsage > 200) {
      if (kDebugMode) {
        debugPrint('WARNING: High memory usage detected: ${report.memoryUsage.toStringAsFixed(1)}MB');
      }
    }
  }

  /// Dispose of the monitor
  void dispose() {
    _memoryMonitorTimer?.cancel();
    _reportingTimer?.cancel();
    _activeOperations.clear();
    _metrics.clear();
    _memorySnapshots.clear();
    _isInitialized = false;
  }
}

/// Performance metric data class
class PerformanceMetric {
  final String name;
  final double value;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceMetric({
    required this.name,
    required this.value,
    required this.timestamp,
    this.metadata,
  });
}

/// Memory snapshot data class
class MemorySnapshot {
  final DateTime timestamp;
  final double usedMemoryMB;

  MemorySnapshot({
    required this.timestamp,
    required this.usedMemoryMB,
  });
}

/// Performance report data class
class PerformanceReport {
  final double averageFPS;
  final double memoryUsage;
  final List<PerformanceMetric> recentMetrics;
  final List<String> activeOperations;

  PerformanceReport({
    required this.averageFPS,
    required this.memoryUsage,
    required this.recentMetrics,
    required this.activeOperations,
  });
}
