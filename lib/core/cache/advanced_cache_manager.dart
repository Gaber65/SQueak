// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// /// Advanced cache manager with TTL, compression, and multiple storage strategies
// class AdvancedCacheManager {
//   static const String _keyPrefix = 'cache_';
//   static const String _expiryPrefix = 'expiry_';

//   static final AdvancedCacheManager _instance =
//       AdvancedCacheManager._internal();
//   factory AdvancedCacheManager() => _instance;
//   AdvancedCacheManager._internal();

//   final Map<String, dynamic> _memoryCache = {};
//   final bool _isInitialized = false;

//   /// Initialize the cache manager
//   Future<void> initialize() async {
//     _prefs = await SharedPreferences.getInstance();
//     _startPeriodicCleanup();
//     await _loadMemoryCache();
//   }

//   /// Cache data with optional TTL and compression
//   Future<void> set<T>({
//     required String key,
//     required T data,
//     Duration? ttl,
//     bool compress = false,
//     CacheStrategy strategy = CacheStrategy.memoryAndDisk,
//   }) async {
//     final expiryTime = DateTime.now().add(ttl ?? _defaultTTL);
//     final jsonData = json.encode(data);
//     final compressedData = compress ? _compress(jsonData) : jsonData;

//     final cacheItem = CacheItem<T>(
//       key: key,
//       data: data,
//       rawData: compressedData,
//       expiryTime: expiryTime,
//       isCompressed: compress,
//       strategy: strategy,
//     );

//     // Store in memory cache
//     if (strategy == CacheStrategy.memoryAndDisk ||
//         strategy == CacheStrategy.memoryOnly) {
//       _addToMemoryCache(key, cacheItem);
//     }

//     // Store in persistent cache
//     if (strategy == CacheStrategy.memoryAndDisk ||
//         strategy == CacheStrategy.diskOnly) {
//       await _saveToDisk(key, cacheItem);
//     }

//     if (kDebugMode) {
//       debugPrint('Cached: $key (${_getSizeText(compressedData.length)})');
//     }
//   }

//   /// Get cached data
//   Future<T?> get<T>(String key) async {
//     // Check memory cache first
//     if (_memoryCache.containsKey(key)) {
//       final item = _memoryCache[key]!;
//       if (!item.isExpired) {
//         if (kDebugMode) {
//           debugPrint('Memory cache hit: $key');
//         }
//         return item.data as T?;
//       } else {
//         _memoryCache.remove(key);
//       }
//     }

//     // Check disk cache
//     final diskItem = await _loadFromDisk<T>(key);
//     if (diskItem != null && !diskItem.isExpired) {
//       // Add back to memory cache if strategy allows
//       if (diskItem.strategy == CacheStrategy.memoryAndDisk) {
//         _addToMemoryCache(key, diskItem);
//       }

//       if (kDebugMode) {
//         debugPrint('Disk cache hit: $key');
//       }
//       return diskItem.data;
//     }

//     if (kDebugMode) {
//       debugPrint('ERROR: Cache miss: $key');
//     }
//     return null;
//   }

//   /// Check if key exists in cache and is not expired
//   Future<bool> exists(String key) async {
//     final item = await get(key);
//     return item != null;
//   }

//   /// Remove specific cache entry
//   Future<void> remove(String key) async {
//     _memoryCache.remove(key);
//     await _prefs?.remove('$_cachePrefix$key');
//     await _prefs?.remove('$_metadataPrefix$key');
//   }

//   /// Clear all cached data
//   Future<void> clear() async {
//     _memoryCache.clear();

//     final prefs = await SharedPreferences.getInstance();
//     final keys =
//         prefs.getKeys().where((key) => key.startsWith(_keyPrefix)).toList();

//     for (final key in keys) {
//       await prefs.remove(key);
//     }

//     if (kDebugMode) {
//       debugPrint('Cleared ${keys.length} cache entries');
//     }
//   }

//   /// Delete cached data
//   Future<void> delete(String key) async {
//     // Remove from memory cache
//     _memoryCache.remove(key);

//     // Remove from disk cache
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_getStorageKey(key));
//     await prefs.remove(_getExpiryKey(key));

//     if (kDebugMode) {
//       debugPrint('Deleted cache key: $key');
//     }
//   }

//   /// Get cache statistics
//   CacheStatistics getStatistics() {
//     final memorySize = _memoryCache.length;
//     final memoryHits =
//         _memoryCache.values.where((item) => !item.isExpired).length;

//     return CacheStatistics(
//       memoryCacheSize: memorySize,
//       memoryCacheHits: memoryHits,
//       totalCacheSize: memorySize, // Simplified for this example
//     );
//   }

//   /// Add item to memory cache with size management
//   void _addToMemoryCache(String key, CacheItem item) {
//     // Remove oldest items if cache is full
//     if (_memoryCache.length >= _maxMemoryCacheSize) {
//       final oldestKey =
//           _memoryCache.entries
//               .reduce(
//                 (a, b) => a.value.createdAt.isBefore(b.value.createdAt) ? a : b,
//               )
//               .key;
//       _memoryCache.remove(oldestKey);
//     }

//     _memoryCache[key] = item;
//   }

//   /// Save cache item to disk
//   Future<void> _saveToDisk(String key, CacheItem item) async {
//     final metadata = {
//       'expiryTime': item.expiryTime.millisecondsSinceEpoch,
//       'isCompressed': item.isCompressed,
//       'strategy': item.strategy.index,
//       'createdAt': item.createdAt.millisecondsSinceEpoch,
//     };

//     await _prefs?.setString('$_cachePrefix$key', item.rawData);
//     await _prefs?.setString('$_metadataPrefix$key', json.encode(metadata));
//   }

//   /// Load cache item from disk
//   Future<CacheItem<T>?> _loadFromDisk<T>(String key) async {
//     final rawData = _prefs?.getString('$_cachePrefix$key');
//     final metadataString = _prefs?.getString('$_metadataPrefix$key');

//     if (rawData == null || metadataString == null) return null;

//     try {
//       final metadata = json.decode(metadataString);
//       final isCompressed = metadata['isCompressed'] as bool;
//       final strategy = CacheStrategy.values[metadata['strategy'] as int];
//       final expiryTime = DateTime.fromMillisecondsSinceEpoch(
//         metadata['expiryTime'] as int,
//       );
//       final createdAt = DateTime.fromMillisecondsSinceEpoch(
//         metadata['createdAt'] as int,
//       );

//       final decompressedData = isCompressed ? _decompress(rawData) : rawData;
//       final data = json.decode(decompressedData) as T;

//       return CacheItem<T>(
//         key: key,
//         data: data,
//         rawData: rawData,
//         expiryTime: expiryTime,
//         isCompressed: isCompressed,
//         strategy: strategy,
//         createdAt: createdAt,
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('Failed to load cache item $key: $e');
//       }
//       return null;
//     }
//   }

//   /// Load frequently used items into memory cache
//   Future<void> _loadMemoryCache() async {
//     final keys = _prefs?.getKeys() ?? <String>{};
//     var loadedCount = 0;

//     for (final key in keys) {
//       if (key.startsWith(_cachePrefix) &&
//           loadedCount < _maxMemoryCacheSize ~/ 2) {
//         final cacheKey = key.substring(_cachePrefix.length);
//         final item = await _loadFromDisk(cacheKey);

//         if (item != null &&
//             !item.isExpired &&
//             (item.strategy == CacheStrategy.memoryAndDisk)) {
//           _memoryCache[cacheKey] = item;
//           loadedCount++;
//         }
//       }
//     }

//     if (kDebugMode) {
//       debugPrint('Loaded $loadedCount items into memory cache');
//     }
//   }

//   /// Start periodic cleanup of expired items
//   void _startPeriodicCleanup() {
//     _cleanupTimer = Timer.periodic(const Duration(hours: 1), (_) {
//       _cleanupExpiredItems();
//     });
//   }

//   /// Clean up expired cache items
//   Future<void> _cleanupExpiredItems() async {
//     // Clean memory cache
//     _memoryCache.removeWhere((key, value) => value.isExpired);

//     // Clean disk cache
//     final keys = _prefs?.getKeys() ?? <String>{};
//     var removedCount = 0;

//     for (final key in keys) {
//       if (key.startsWith(_metadataPrefix)) {
//         final cacheKey = key.substring(_metadataPrefix.length);
//         final item = await _loadFromDisk(cacheKey);

//         if (item != null && item.isExpired) {
//           await remove(cacheKey);
//           removedCount++;
//         }
//       }
//     }

//     if (kDebugMode && removedCount > 0) {
//       debugPrint('Cleaned up $removedCount expired cache items');
//     }
//   }

//   /// Simple compression (in production, use a proper compression library)
//   String _compress(String data) {
//     // This is a placeholder - implement actual compression
//     return data;
//   }

//   /// Simple decompression
//   String _decompress(String data) {
//     // This is a placeholder - implement actual decompression
//     return data;
//   }

//   /// Get human-readable size text
//   String _getSizeText(int bytes) {
//     if (bytes < 1024) return '${bytes}B';
//     if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
//     return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
//   }

//   /// Dispose resources
//   void dispose() {
//     _cleanupTimer?.cancel();
//     _memoryCache.clear();
//   }
// }

// /// Cache item wrapper
// class CacheItem<T> {
//   final String key;
//   final T data;
//   final String rawData;
//   final DateTime expiryTime;
//   final bool isCompressed;
//   final CacheStrategy strategy;
//   final DateTime createdAt;

//   CacheItem({
//     required this.key,
//     required this.data,
//     required this.rawData,
//     required this.expiryTime,
//     required this.isCompressed,
//     required this.strategy,
//     DateTime? createdAt,
//   }) : createdAt = createdAt ?? DateTime.now();

//   bool get isExpired => DateTime.now().isAfter(expiryTime);
// }

// /// Cache strategy options
// enum CacheStrategy { memoryOnly, diskOnly, memoryAndDisk }

// /// Cache statistics
// class CacheStatistics {
//   final int memoryCacheSize;
//   final int memoryCacheHits;
//   final int totalCacheSize;

//   CacheStatistics({
//     required this.memoryCacheSize,
//     required this.memoryCacheHits,
//     required this.totalCacheSize,
//   });

//   double get hitRate =>
//       memoryCacheSize > 0 ? memoryCacheHits / memoryCacheSize : 0.0;

//   @override
//   String toString() {
//     return 'Cache Stats: Memory($memoryCacheSize), Hits($memoryCacheHits), Hit Rate(${(hitRate * 100).toStringAsFixed(1)}%)';
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Advanced cache manager with TTL, compression, and multiple storage strategies
class AdvancedCacheManager {
  // Storage key prefixes (consistent)
  static const String _cachePrefix = 'cache_';
  static const String _metadataPrefix = 'meta_';

  static final AdvancedCacheManager _instance =
      AdvancedCacheManager._internal();
  factory AdvancedCacheManager() => _instance;
  AdvancedCacheManager._internal();

  // --- Internal fields ---
  late SharedPreferences _prefs;
  bool _isInitialized = false;
  Timer? _cleanupTimer;

  final Map<String, CacheItem<dynamic>> _memoryCache = {};

  // Configurable defaults
  final Duration _defaultTTL = const Duration(days: 1);
  final int _maxMemoryCacheSize = 100;

  /// Initialize the cache manager
  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    await _loadMemoryCache();
    _startPeriodicCleanup();
    if (kDebugMode) debugPrint('AdvancedCacheManager initialized');
  }

  /// Cache data with optional TTL and compression
  Future<void> set<T>({
    required String key,
    required T data,
    Duration? ttl,
    bool compress = false,
    CacheStrategy strategy = CacheStrategy.memoryAndDisk,
  }) async {
    if (!_isInitialized) await initialize();

    final expiryTime = DateTime.now().add(ttl ?? _defaultTTL);
    final jsonData = json.encode(data);
    final compressedData = compress ? _compress(jsonData) : jsonData;

    final cacheItem = CacheItem<T>(
      key: key,
      data: data,
      rawData: compressedData,
      expiryTime: expiryTime,
      isCompressed: compress,
      strategy: strategy,
    );

    // Store in memory cache
    if (strategy == CacheStrategy.memoryAndDisk ||
        strategy == CacheStrategy.memoryOnly) {
      _addToMemoryCache(key, cacheItem);
    }

    // Store in persistent cache
    if (strategy == CacheStrategy.memoryAndDisk ||
        strategy == CacheStrategy.diskOnly) {
      await _saveToDisk(key, cacheItem);
    }

    if (kDebugMode) {
      debugPrint('Cached: $key (${_getSizeText(compressedData.length)})');
    }
  }

  /// Get cached data
  Future<T?> get<T>(String key) async {
    if (!_isInitialized) await initialize();

    // Check memory cache first
    final memItem = _memoryCache[key];
    if (memItem != null) {
      if (!memItem.isExpired) {
        if (kDebugMode) debugPrint('Memory cache hit: $key');
        return memItem.data as T?;
      } else {
        _memoryCache.remove(key);
      }
    }

    // Check disk cache
    final diskItem = await _loadFromDisk<T>(key);
    if (diskItem != null && !diskItem.isExpired) {
      // Add back to memory cache if strategy allows
      if (diskItem.strategy == CacheStrategy.memoryAndDisk) {
        _addToMemoryCache(key, diskItem);
      }

      if (kDebugMode) {
        debugPrint('Disk cache hit: $key');
      }
      return diskItem.data;
    }

    if (kDebugMode) {
      debugPrint('Cache miss: $key');
    }
    return null;
  }

  /// Check if key exists in cache and is not expired
  Future<bool> exists(String key) async {
    final item = await get(key);
    return item != null;
  }

  /// Remove specific cache entry (from both memory and disk)
  Future<void> remove(String key) async {
    if (!_isInitialized) await initialize();

    _memoryCache.remove(key);
    await _prefs.remove(_getStorageKey(key));
    await _prefs.remove(_getMetadataKey(key));

    if (kDebugMode) debugPrint('Removed cache key: $key');
  }

  /// Clear all cached data (disk + memory)
  Future<void> clear() async {
    if (!_isInitialized) await initialize();

    _memoryCache.clear();

    final keys =
        _prefs.getKeys().where((k) => k.startsWith(_cachePrefix)).toList();

    for (final key in keys) {
      await _prefs.remove(key);
    }

    final metaKeys =
        _prefs.getKeys().where((k) => k.startsWith(_metadataPrefix)).toList();

    for (final key in metaKeys) {
      await _prefs.remove(key);
    }

    if (kDebugMode) {
      debugPrint('Cleared ${keys.length + metaKeys.length} cache entries');
    }
  }

  /// Delete cached data (alias for remove)
  Future<void> delete(String key) async {
    await remove(key);
  }

  /// Get cache statistics
  CacheStatistics getStatistics() {
    final memorySize = _memoryCache.length;
    final memoryHits =
        _memoryCache.values.where((item) => !item.isExpired).length;

    return CacheStatistics(
      memoryCacheSize: memorySize,
      memoryCacheHits: memoryHits,
      totalCacheSize:
          memorySize, // Could be enhanced to sum disk size; simplified here
    );
  }

  /// Add item to memory cache with size management
  void _addToMemoryCache(String key, CacheItem item) {
    // Remove oldest items if cache is full
    if (_memoryCache.length >= _maxMemoryCacheSize) {
      final oldestEntry = _memoryCache.entries.reduce(
        (a, b) => a.value.createdAt.isBefore(b.value.createdAt) ? a : b,
      );
      _memoryCache.remove(oldestEntry.key);
    }

    _memoryCache[key] = item;
  }

  /// Save cache item to disk
  Future<void> _saveToDisk(String key, CacheItem item) async {
    if (!_isInitialized) await initialize();

    final metadata = {
      'expiryTime': item.expiryTime.millisecondsSinceEpoch,
      'isCompressed': item.isCompressed,
      'strategy': item.strategy.index,
      'createdAt': item.createdAt.millisecondsSinceEpoch,
    };

    await _prefs.setString(_getStorageKey(key), item.rawData);
    await _prefs.setString(_getMetadataKey(key), json.encode(metadata));
  }

  /// Load cache item from disk
  Future<CacheItem<T>?> _loadFromDisk<T>(String key) async {
    if (!_isInitialized) await initialize();

    final rawData = _prefs.getString(_getStorageKey(key));
    final metadataString = _prefs.getString(_getMetadataKey(key));

    if (rawData == null || metadataString == null) return null;

    try {
      final metadata = json.decode(metadataString) as Map<String, dynamic>;
      final isCompressed = metadata['isCompressed'] as bool? ?? false;
      final strategyIdx = metadata['strategy'] as int? ?? 0;
      final strategy = CacheStrategy.values[strategyIdx];
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(
        metadata['expiryTime'] as int? ?? 0,
      );
      final createdAt = DateTime.fromMillisecondsSinceEpoch(
        metadata['createdAt'] as int? ?? 0,
      );

      final decompressedData = isCompressed ? _decompress(rawData) : rawData;

      // Attempt to decode JSON to Dart object
      final decoded = json.decode(decompressedData);

      // Try to cast to T (best-effort; complex generics may need custom handling)
      final data = decoded as T;

      return CacheItem<T>(
        key: key,
        data: data,
        rawData: rawData,
        expiryTime: expiryTime,
        isCompressed: isCompressed,
        strategy: strategy,
        createdAt: createdAt,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Failed to load cache item $key: $e');
      return null;
    }
  }

  /// Load frequently used items into memory cache
  Future<void> _loadMemoryCache() async {
    if (!_isInitialized) return;

    final keys = _prefs.getKeys();
    var loadedCount = 0;

    for (final key in keys) {
      if (key.startsWith(_cachePrefix) &&
          loadedCount < _maxMemoryCacheSize ~/ 2) {
        final cacheKey = key.substring(_cachePrefix.length);
        final item = await _loadFromDisk(cacheKey);

        if (item != null &&
            !item.isExpired &&
            (item.strategy == CacheStrategy.memoryAndDisk)) {
          _memoryCache[cacheKey] = item;
          loadedCount++;
        }
      }
    }

    if (kDebugMode) {
      debugPrint('Loaded $loadedCount items into memory cache');
    }
  }

  /// Start periodic cleanup of expired items
  void _startPeriodicCleanup() {
    // Cancel existing timer if any
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(const Duration(hours: 1), (_) {
      _cleanupExpiredItems();
    });
  }

  /// Clean up expired cache items
  Future<void> _cleanupExpiredItems() async {
    if (!_isInitialized) return;

    // Clean memory cache
    _memoryCache.removeWhere((key, value) => value.isExpired);

    // Clean disk cache
    final keys = _prefs.getKeys();
    var removedCount = 0;

    for (final key in keys) {
      if (key.startsWith(_metadataPrefix)) {
        final cacheKey = key.substring(_metadataPrefix.length);
        final item = await _loadFromDisk(cacheKey);

        if (item != null && item.isExpired) {
          await remove(cacheKey);
          removedCount++;
        }
      }
    }

    if (kDebugMode && removedCount > 0) {
      debugPrint('Cleaned up $removedCount expired cache items');
    }
  }

  // Helper to build storage key
  String _getStorageKey(String key) => '$_cachePrefix$key';
  String _getMetadataKey(String key) => '$_metadataPrefix$key';

  /// Simple compression (in production, use a proper compression library)
  String _compress(String data) {
    // Placeholder - implement actual compression if desired
    return data;
  }

  /// Simple decompression
  String _decompress(String data) {
    // Placeholder - implement actual decompression if desired
    return data;
  }

  /// Get human-readable size text
  String _getSizeText(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// Dispose resources
  void dispose() {
    _cleanupTimer?.cancel();
    _memoryCache.clear();
    _isInitialized = false;
  }
}

/// Cache item wrapper
class CacheItem<T> {
  final String key;
  final T data;
  final String rawData;
  final DateTime expiryTime;
  final bool isCompressed;
  final CacheStrategy strategy;
  final DateTime createdAt;

  CacheItem({
    required this.key,
    required this.data,
    required this.rawData,
    required this.expiryTime,
    required this.isCompressed,
    required this.strategy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}

/// Cache strategy options
enum CacheStrategy { memoryOnly, diskOnly, memoryAndDisk }

/// Cache statistics
class CacheStatistics {
  final int memoryCacheSize;
  final int memoryCacheHits;
  final int totalCacheSize;

  CacheStatistics({
    required this.memoryCacheSize,
    required this.memoryCacheHits,
    required this.totalCacheSize,
  });

  double get hitRate =>
      memoryCacheSize > 0 ? memoryCacheHits / memoryCacheSize : 0.0;

  @override
  String toString() {
    return 'Cache Stats: Memory($memoryCacheSize), Hits($memoryCacheHits), Hit Rate(${(hitRate * 100).toStringAsFixed(1)}%)';
  }
}
