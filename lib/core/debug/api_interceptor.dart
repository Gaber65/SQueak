import 'package:dio/dio.dart';
import 'package:squeak/core/debug/api_logger.dart';

class ApiLoggerInterceptor extends Interceptor {
  final logger = ApiLogger.instance;
  final Map<String, DateTime> _startTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final id = options.hashCode.toString();
    
    // Store start time
    _startTimes[id] = DateTime.now();

    // Log the request
    logger.addCall(
      ApiCall(
        id: id,
        method: options.method,
        url: options.uri.toString(),
        requestHeaders: options.headers.map((key, value) => MapEntry(key, value.toString())),
        requestBody: options.data,
        timestamp: DateTime.now(),
      ),
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final id = response.requestOptions.hashCode.toString();
    final startTime = _startTimes[id];

    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _startTimes.remove(id);

      // Update the call with response data and duration
      logger.updateCall(
        id,
        statusCode: response.statusCode,
        responseHeaders: response.headers.map.map(
          (key, value) => MapEntry(key, value.join(', ')),
        ),
        responseBody: response.data,
        duration: duration,
      );
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final id = err.requestOptions.hashCode.toString();
    final startTime = _startTimes[id];

    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _startTimes.remove(id);

      logger.updateCall(
        id,
        statusCode: err.response?.statusCode,
        responseHeaders: err.response?.headers.map.map(
          (key, value) => MapEntry(key, value.join(', ')),
        ),
        responseBody: err.response?.data ?? err.message,
        duration: duration,
        error: err.message,
      );
    }

    super.onError(err, handler);
  }
}