/// Temporarily disabled performance monitor to identify crash sources
class AdvancedPerformanceMonitor {
  static final AdvancedPerformanceMonitor _instance = AdvancedPerformanceMonitor._internal();
  factory AdvancedPerformanceMonitor() => _instance;
  AdvancedPerformanceMonitor._internal();

  /// All methods are no-ops to prevent crashes
  Future<void> initialize() async {
    // Disabled
  }

  void startOperation(String operationName) {
    // Disabled
  }

  void endOperation(String operationName, {Map<String, dynamic>? metadata}) {
    // Disabled
  }

  void recordException(Object exception, StackTrace? stackTrace) {
    // Disabled
  }

  void trackNetworkRequest(String endpoint, int responseTime) {
    // Disabled
  }

  void trackWidgetBuild(String widgetName, int buildTime) {
    // Disabled
  }

  void dispose() {
    // Disabled
  }
}

/// Placeholder classes for compatibility
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

class MemorySnapshot {
  final DateTime timestamp;
  final double usedMemoryMB;

  MemorySnapshot({
    required this.timestamp,
    required this.usedMemoryMB,
  });
}

class PerformanceReport {
  final double averageFPS;
  final double memoryUsage;
  final List<String> activeOperations;
  final List<PerformanceMetric> recentMetrics;

  PerformanceReport({
    required this.averageFPS,
    required this.memoryUsage,
    required this.activeOperations,
    required this.recentMetrics,
  });
}
