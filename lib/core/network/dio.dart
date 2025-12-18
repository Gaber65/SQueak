import 'package:dio/dio.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/debug/api_interceptor.dart';

class DioFinalHelper {
  static late Dio dio;
  static Environment? _currentEnvironment;

  // Store cancel tokens for each request
  static final Map<String, CancelToken> _cancelTokens = {};

  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
    DebugUtils.debugPrintEnv(
      'DioFinalHelper: Environment set to ${environment.name}',
    );
  }

  static Map<String, String> _buildHeaders({String? token}) {
    return {
      "Content-Type": "application/json",
      "Accept-Language": isArabic() ? 'ar' : 'en',
      "Authorization": "Bearer ${token ?? CacheHelper.getData('token')}",
    };
  }

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ConfigModel.baseApiUrlSqueak,
        receiveDataWhenStatusError: true,
        headers: _buildHeaders(),
      ),
    );

    if (_currentEnvironment == Environment.test) {
      dio.interceptors.add(ApiLoggerInterceptor());
      DebugUtils.debugPrintEnv(
        'DioFinalHelper: ApiInterceptor added for test environment',
      );
    } else {
      DebugUtils.debugPrintEnv(
        'DioFinalHelper: ApiInterceptor skipped for ${_currentEnvironment?.name ?? 'unknown'} environment',
      );
    }
  }

  static Future<void> _ensureValidToken() async {
    final isExpired = await TokenManager.isAccessTokenExpired();
    if (isExpired) {
      await TokenManager.refreshToken();
    }
  }

  // Modified getData with cancellation support
  static Future<Response> getData({
    required String method,
    String? token,
    Map<String, dynamic>? query,
    bool language = false,
    String? requestId, // Optional ID for cancellation
  }) async {
    await _ensureValidToken();

    // Create cancel token if requestId is provided
    CancelToken? cancelToken;
    if (requestId != null) {
      cancelToken = CancelToken();
      _cancelTokens[requestId] = cancelToken;
    }

    dio.options.headers = {
      'Authorization': 'Bearer ${token ?? CacheHelper.getData('token')}',
      'Accept-Language':
          language
              ? 'en'
              : isArabic()
              ? 'ar'
              : 'en',
    };

    if (query != null) {
      dio.options.queryParameters = query;
    }

    try {
      return await dio.get(method, cancelToken: cancelToken);
    } finally {
      // Remove the cancel token from map after request completes
      if (requestId != null) {
        _cancelTokens.remove(requestId);
      }
    }
  }

  // Modified postData with cancellation support
  static Future<Response> postData({
    required String method,
    required dynamic data,
    String? token,
    String? requestId, // Optional ID for cancellation
  }) async {
    await _ensureValidToken();

    // Create cancel token if requestId is provided
    CancelToken? cancelToken;
    if (requestId != null) {
      cancelToken = CancelToken();
      _cancelTokens[requestId] = cancelToken;
    }

    dio.options.headers = _buildHeaders(token: token);

    try {
      return await dio.post(method, data: data, cancelToken: cancelToken);
    } finally {
      // Remove the cancel token from map after request completes
      if (requestId != null) {
        _cancelTokens.remove(requestId);
      }
    }
  }

  // Modified putData with cancellation support
  static Future<Response> putData({
    required String method,
    required Map<String, dynamic> data,
    String? token,
    String? requestId, // Optional ID for cancellation
  }) async {
    await _ensureValidToken();

    CancelToken? cancelToken;
    if (requestId != null) {
      cancelToken = CancelToken();
      _cancelTokens[requestId] = cancelToken;
    }

    dio.options.headers = _buildHeaders(token: token);

    try {
      return await dio.put(method, data: data, cancelToken: cancelToken);
    } finally {
      if (requestId != null) {
        _cancelTokens.remove(requestId);
      }
    }
  }

  // CORRECTED: Method to cancel a specific request
  static void cancelRequestById(String requestId) {
    final cancelToken = _cancelTokens[requestId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Request cancelled by user');
      _cancelTokens.remove(requestId);
      DebugUtils.debugPrintEnv('Request $requestId cancelled');
    }
  }

  // Method to cancel all pending requests
  static void cancelAllRequests() {
    _cancelTokens.forEach((id, token) {
      if (!token.isCancelled) {
        token.cancel('All requests cancelled');
      }
    });
    _cancelTokens.clear();
    DebugUtils.debugPrintEnv('All requests cancelled');
  }

  static Future<Response> patchData({
    required String method,
    required Map<String, dynamic> data,
    String? token,
    String? requestId,
  }) async {
    await _ensureValidToken();

    CancelToken? cancelToken;
    if (requestId != null) {
      cancelToken = CancelToken();
      _cancelTokens[requestId] = cancelToken;
    }

    dio.options.headers = _buildHeaders(token: token);

    try {
      return await dio.patch(method, data: data, cancelToken: cancelToken);
    } finally {
      if (requestId != null) {
        _cancelTokens.remove(requestId);
      }
    }
  }

  static Future<Response> deleteData({
    required String method,
    String? token,
    Map<String, dynamic>? data,
    String? requestId,
  }) async {
    await _ensureValidToken();

    CancelToken? cancelToken;
    if (requestId != null) {
      cancelToken = CancelToken();
      _cancelTokens[requestId] = cancelToken;
    }

    dio.options.headers = _buildHeaders(token: token);

    try {
      return await dio.delete(method, data: data, cancelToken: cancelToken);
    } finally {
      if (requestId != null) {
        _cancelTokens.remove(requestId);
      }
    }
  }

  // Get all active request IDs
  static List<String> getActiveRequestIds() {
    return _cancelTokens.keys.toList();
  }

  // Check if a specific request is still active
  static bool isRequestActive(String requestId) {
    return _cancelTokens.containsKey(requestId);
  }
}

// Helper function to generate unique request IDs
String generateRequestId(String method, [String suffix = '']) {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return '${method}_${timestamp}_$suffix';
}

String extractFirstError(dynamic error) {
  try {
    final entries = error.error.errors?.entries;
    if (entries != null && entries.isNotEmpty) {
      final firstValues = entries.first.value;
      if (firstValues != null && firstValues.isNotEmpty) {
        return firstValues.first;
      }
    }
    return error.error.message ?? "Unknown error";
  } catch (_) {
    return "Unknown error";
  }
}

String extractFirstErrorAuth(ErrorMessageModel error) {
  try {
    final entries = error.errors.entries;
    if (entries.isNotEmpty) {
      final firstValues = entries.first.value;
      if (firstValues.isNotEmpty) {
        return firstValues.first;
      }
    }
    return error.message;
  } catch (_) {
    return "Unknown error";
  }
}
