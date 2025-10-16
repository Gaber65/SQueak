import 'dart:async';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:squeak/core/cache/advanced_cache_manager.dart';

/// Advanced offline capability manager with data synchronization
class OfflineManager {
  static final OfflineManager _instance = OfflineManager._internal();
  factory OfflineManager() => _instance;
  OfflineManager._internal();

  final Connectivity _connectivity = Connectivity();
  final AdvancedCacheManager _cache = AdvancedCacheManager();
  final List<OfflineOperation> _pendingOperations = [];

  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _syncTimer;

  /// Initialize offline manager
  Future<void> initialize() async {
    await _cache.initialize();
    await _checkInitialConnectivity();
    _startConnectivityMonitoring();
    _startPeriodicSync();
    await _loadPendingOperations();
  }

  /// Check if device is currently online
  bool get isOnline => _isOnline;

  /// Get cached data with offline fallback
  Future<T?> getData<T>({
    required String key,
    required Future<T> Function() onlineDataFetcher,
    Duration? cacheTTL,
  }) async {
    try {
      if (_isOnline) {
        // Try to fetch fresh data
        final freshData = await onlineDataFetcher();

        // Cache the fresh data
        await _cache.set(
          key: key,
          data: freshData,
          ttl: cacheTTL ?? const Duration(hours: 24),
          strategy: CacheStrategy.memoryAndDisk,
        );

        return freshData;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('WARNING: Online fetch failed: $e, falling back to cache');
      }
    }

    // Fallback to cached data
    final cachedData = await _cache.get<T>(key);
    if (cachedData != null) {
      if (kDebugMode) {
        debugPrint('Using cached data for: $key');
      }
      return cachedData;
    }

    if (kDebugMode) {
      debugPrint('ERROR: No data available for: $key');
    }
    return null;
  }

  /// Queue operation for when online
  Future<void> queueOperation(OfflineOperation operation) async {
    _pendingOperations.add(operation);

    // Save to persistent storage
    await _savePendingOperations();

    if (kDebugMode) {
      debugPrint(
        'Queued operation: ${operation.type} (${_pendingOperations.length} pending)',
      );
    }

    // Try to sync immediately if online
    if (_isOnline) {
      await _syncPendingOperations();
    }
  }

  /// Force sync all pending operations
  Future<void> forcSync() async {
    if (_isOnline) {
      await _syncPendingOperations();
    }
  }

  /// Get offline status information
  OfflineStatus getStatus() {
    return OfflineStatus(
      isOnline: _isOnline,
      pendingOperationsCount: _pendingOperations.length,
      lastSyncTime: DateTime.now(), // Simplified for this example
    );
  }

  /// Check initial connectivity status
  Future<void> _checkInitialConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(results);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to check connectivity: $e');
      }
    }
  }

  /// Start monitoring connectivity changes
  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectivityStatus,
      onError: (error) {
        if (kDebugMode) {
          debugPrint('Connectivity monitoring error: $error');
        }
      },
    );
  }

  /// Update connectivity status
  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    if (kDebugMode) {
      debugPrint('Connectivity changed: ${_isOnline ? "ONLINE" : "OFFLINE"}');
    }

    // Sync when coming back online
    if (!wasOnline && _isOnline) {
      _syncPendingOperations();
    }
  }

  /// Start periodic sync attempts
  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (_isOnline && _pendingOperations.isNotEmpty) {
        _syncPendingOperations();
      }
    });
  }

  /// Sync all pending operations
  Future<void> _syncPendingOperations() async {
    if (!_isOnline || _pendingOperations.isEmpty) return;

    final operationsToSync = List<OfflineOperation>.from(_pendingOperations);
    final successfulOperations = <OfflineOperation>[];

    for (final operation in operationsToSync) {
      try {
        final success = await _executeOperation(operation);
        if (success) {
          successfulOperations.add(operation);
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('ERROR: Failed to sync operation ${operation.id}: $e');
        }
      }
    }

    // Remove successful operations
    for (final operation in successfulOperations) {
      _pendingOperations.remove(operation);
    }

    // Update persistent storage
    await _savePendingOperations();

    if (kDebugMode && successfulOperations.isNotEmpty) {
      debugPrint('SUCCESS: Synced ${successfulOperations.length} operations');
    }
  }

  /// Execute a single operation
  Future<bool> _executeOperation(OfflineOperation operation) async {
    // This would integrate with your API client
    // For now, we'll simulate the operation

    if (kDebugMode) {
      debugPrint('Executing ${operation.type}: ${operation.id}');
    }

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate success/failure (90% success rate)
    return DateTime.now().millisecond % 10 != 0;
  }

  /// Save pending operations to persistent storage
  Future<void> _savePendingOperations() async {
    final data = _pendingOperations.map((op) => op.toJson()).toList();
    await _cache.set(
      key: 'pending_operations',
      data: data,
      ttl: const Duration(days: 30), // Keep for 30 days
      strategy: CacheStrategy.diskOnly,
    );
  }

  /// Load pending operations from persistent storage
  Future<void> _loadPendingOperations() async {
    final data = await _cache.get<List<dynamic>>('pending_operations');
    if (data != null) {
      _pendingOperations.clear();
      for (final item in data) {
        try {
          _pendingOperations.add(OfflineOperation.fromJson(item));
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Failed to parse pending operation: $e');
          }
        }
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
  }
}

/// Represents an operation that can be queued for offline sync
class OfflineOperation {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;

  OfflineOperation({
    required this.id,
    required this.type,
    required this.data,
    DateTime? createdAt,
    this.retryCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create operation with incremented retry count
  OfflineOperation withRetry() {
    return OfflineOperation(
      id: id,
      type: type,
      data: data,
      createdAt: createdAt,
      retryCount: retryCount + 1,
    );
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }

  /// Create from JSON
  factory OfflineOperation.fromJson(Map<String, dynamic> json) {
    return OfflineOperation(
      id: json['id'],
      type: json['type'],
      data: Map<String, dynamic>.from(json['data']),
      createdAt: DateTime.parse(json['createdAt']),
      retryCount: json['retryCount'] ?? 0,
    );
  }
}

/// Offline status information
class OfflineStatus {
  final bool isOnline;
  final int pendingOperationsCount;
  final DateTime lastSyncTime;

  OfflineStatus({
    required this.isOnline,
    required this.pendingOperationsCount,
    required this.lastSyncTime,
  });

  @override
  String toString() {
    return 'Offline Status: ${isOnline ? "Online" : "Offline"}, Pending: $pendingOperationsCount';
  }
}
