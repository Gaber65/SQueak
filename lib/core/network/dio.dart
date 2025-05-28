import 'package:dio/dio.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../service/refresh_token_manger/token_manager.dart';
import 'config_model.dart';

class DioFinalHelper {
  static late Dio dio;

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
    dio.interceptors.add(ChuckerDioInterceptor());
  }

  static Future<void> _ensureValidToken() async {
    final isExpired = await TokenManager.isAccessTokenExpired();
    if (isExpired) {
      await TokenManager.refreshToken();
    }
  }

  static Future<Response> getData({
    required String method,
    String? token,
    required bool language,
  }) async {
    await _ensureValidToken();
    dio.options.headers = {
      'Authorization': 'Bearer ${token ?? CacheHelper.getData('token')}',
      'Accept-Language': language
          ? 'en'
          : isArabic()
          ? 'ar'
          : 'en',
    };
    return await dio.get(method);
  }

  static Future<Response> postData({
    required String method,
    required dynamic data,
    String? token,
  }) async {
    await _ensureValidToken();
    dio.options.headers = _buildHeaders(token: token);
    return await dio.post(method, data: data);
  }

  static Future<Response> putData({
    required String method,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    await _ensureValidToken();
    dio.options.headers = _buildHeaders(token: token);
    return await dio.put(method, data: data);
  }

  static Future<Response> patchData({
    required String method,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    await _ensureValidToken();
    dio.options.headers = _buildHeaders(token: token);
    return await dio.patch(method, data: data);
  }

  static Future<Response> deleteData({
    required String method,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    await _ensureValidToken();
    dio.options.headers = _buildHeaders(token: token);
    return await dio.delete(method, data: data);
  }
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
    return error.message ?? "Unknown error";
  } catch (_) {
    return "Unknown error";
  }
}