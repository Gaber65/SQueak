import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

/// Helper class for managing Firebase tokens and messaging
class FirebaseTokenHelper {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static const String _tokenCacheKey = 'DeviceToken';
  static const String _apnsTokenCacheKey = 'APNSToken';

  /// Get Firebase token with proper error handling and fallback
  static Future<String?> getFirebaseToken() async {
    try {
      // Ensure CacheHelper is initialized before using it
      try {
        String? cachedToken = CacheHelper.getData(_tokenCacheKey);
        if (cachedToken != null && cachedToken.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('Using cached Firebase token');
          }
          return cachedToken;
        }
      } catch (cacheError) {
        if (kDebugMode) {
          debugPrint('Cache not available yet, proceeding with fresh token: $cacheError');
        }
      }

      // If no cached token, get fresh token
      if (kDebugMode) {
        debugPrint('Fetching fresh Firebase token...');
      }

      // For iOS, ensure APNS token is available first
      if (Platform.isIOS) {
        await _ensureApnsToken();
      }

      // Get FCM token
      final token = await _messaging.getToken();
      
      if (token != null) {
        // Try to cache the token (ignore errors if cache not ready)
        try {
          await CacheHelper.saveData(_tokenCacheKey, token);
        } catch (cacheError) {
          if (kDebugMode) {
            debugPrint('WARNING: Could not cache token (cache not ready): $cacheError');
          }
        }
        if (kDebugMode) {
          debugPrint('SUCCESS: Firebase token obtained and cached');
        }
        return token;
      } else {
        if (kDebugMode) {
          debugPrint('WARNING: Firebase token is null');
        }
        return _generateFallbackToken();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Error getting Firebase token: $e');
      }
      return _generateFallbackToken();
    }
  }

  /// Ensure APNS token is available for iOS
  static Future<void> _ensureApnsToken() async {
    try {
      // Check if we have a cached APNS token
      String? cachedApnsToken = CacheHelper.getData(_apnsTokenCacheKey);
      if (cachedApnsToken != null && cachedApnsToken.isNotEmpty) {
        if (kDebugMode) {
          debugPrint('SUCCESS: Using cached APNS token');
        }
        return;
      }

      // Try to get APNS token
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        await CacheHelper.saveData(_apnsTokenCacheKey, apnsToken);
        if (kDebugMode) {
          debugPrint('SUCCESS: APNS token obtained and cached');
        }
      } else {
        // Request permissions if APNS token is not available
        if (kDebugMode) {
          debugPrint('WARNING: APNS token not available, requesting permissions...');
        }
        
        await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        // Wait a bit and try again
        await Future.delayed(const Duration(seconds: 1));
        final retryApnsToken = await _messaging.getAPNSToken();
        if (retryApnsToken != null) {
          await CacheHelper.saveData(_apnsTokenCacheKey, retryApnsToken);
          if (kDebugMode) {
            debugPrint('SUCCESS: APNS token obtained after permission request');
          }
        } else {
          if (kDebugMode) {
            debugPrint('WARNING: APNS token still not available, continuing with FCM token only');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('WARNING: APNS token setup error (non-critical): $e');
      }
      // Continue without APNS token - FCM should still work
    }
  }

  /// Generate a fallback token when Firebase is not available
  static String _generateFallbackToken() {
    final fallbackToken = 'fallback_token_${DateTime.now().millisecondsSinceEpoch}';
    if (kDebugMode) {
      debugPrint('Using fallback token: $fallbackToken');
    }
    return fallbackToken;
  }

  /// Refresh the Firebase token
  static Future<String?> refreshToken() async {
    try {
      // Clear cached tokens
      await CacheHelper.removeData(_tokenCacheKey);
      if (Platform.isIOS) {
        await CacheHelper.removeData(_apnsTokenCacheKey);
      }
      
      if (kDebugMode) {
        debugPrint('Refreshing Firebase token...');
      }
      
      // Get fresh token
      return await getFirebaseToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Error refreshing Firebase token: $e');
      }
      return _generateFallbackToken();
    }
  }

  /// Check if Firebase messaging is properly initialized
  static Future<bool> isFirebaseInitialized() async {
    try {
      await _messaging.getToken();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ERROR: Firebase messaging not properly initialized: $e');
      }
      return false;
    }
  }

  /// Setup token refresh listener
  static void setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) async {
      if (kDebugMode) {
        debugPrint('Firebase token refreshed');
      }
      await CacheHelper.saveData(_tokenCacheKey, newToken);
    });
  }
}
