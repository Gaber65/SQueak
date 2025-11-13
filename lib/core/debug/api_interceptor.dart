import 'package:dio/dio.dart';
import 'api_logger.dart';

String _makeId() => DateTime.now().microsecondsSinceEpoch.toString();

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  final id = _makeId();
    final apiCall = ApiCall(
      id: id,
      method: options.method,
      url: options.uri.toString(),
      requestHeaders: Map<String, dynamic>.from(options.headers.map((k, v) => MapEntry(k.toString(), v)) ),
      requestBody: options.data,
    );
    ApiLogger.instance.addCall(apiCall);
    options.extra['__api_logger_id'] = id;
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final id = response.requestOptions.extra['__api_logger_id'] as String?;
      if (id != null) {
        ApiLogger.instance.updateCall(
          id,
          statusCode: response.statusCode,
          responseBody: response.data,
          responseHeaders: response.headers.map.map((k, v) => MapEntry(k, v.join(','))),
          duration: Duration.zero,
        );
      }
    } catch (_) {}
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    try {
      final id = err.requestOptions.extra['__api_logger_id'] as String?;
      if (id != null) {
        ApiLogger.instance.updateCall(
          id,
          statusCode: err.response?.statusCode,
          responseBody: err.response?.data ?? err.message,
          responseHeaders: err.response?.headers.map.map((k, v) => MapEntry(k, v.join(','))),
          duration: Duration.zero,
          error: err.message,
        );
      }
    } catch (_) {}
    handler.next(err);
  }
}
