import 'package:dio/dio.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import '../service/global_function/format_utils.dart';
import 'config_model.dart';

class DioFinalHelper {
  static late Dio dio;


  static Map<String, String> _buildHeaders({String? token, bool includeCookie = true}) {
    return {
      "Content-Type": "application/json",
      "Accept-Language": isArabic() ? 'ar' : 'en',
      'Authorization': 'Bearer ${token ?? CacheHelper.getData('refreshToken')}',
    };
  }

  static  init() {
    dio = Dio(
      BaseOptions(
        baseUrl: ConfigModel.baseApiUrlSqueak,
        receiveDataWhenStatusError: true,
        headers: _buildHeaders(),
      ),
    );

    dio.interceptors.add(ChuckerDioInterceptor());
  }

  static Future<Response> postData({
    required String method,
    required dynamic data,
    String? token,
  }) async {
    dio.options.headers = _buildHeaders(token: token);
    return await dio.post(method, data: data);
  }

  static Future<Response> getData({
    required String method,
    String? token,
    required bool language,
  }) async {
    dio.options.headers = {
      'Authorization': 'Bearer ${token ?? CacheHelper.getData('refreshToken')}',
      'Accept-Language': language
          ? 'en'
          : isArabic()
          ? 'ar'
          : 'en',
    };
    return await dio.get(method);
  }

  static Future<Response> putData({
    required String method,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers = _buildHeaders(token: token, includeCookie: false);
    return await dio.put(method, data: data);
  }

  static Future<Response> patchData({
    required String method,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers = _buildHeaders(token: token);
    return await dio.patch(method, data: data);
  }

  static Future<Response> deleteData({
    required String method,
    String? token,
    Map<String, dynamic>? data,
  }) async {
    dio.options.headers = _buildHeaders(token: token);
    return await dio.delete(method, data: data);
  }
}
