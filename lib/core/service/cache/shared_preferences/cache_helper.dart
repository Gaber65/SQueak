import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String _xorEncrypt(String data, String key) {
    final dataBytes = utf8.encode(data);
    final keyBytes = utf8.encode(key);

    final encrypted = List<int>.generate(
      dataBytes.length,
          (i) => dataBytes[i] ^ keyBytes[i % keyBytes.length],
    );

    return base64.encode(encrypted);
  }

  static String _xorDecrypt(String encryptedData, String key) {
    final encryptedBytes = base64.decode(encryptedData);
    final keyBytes = utf8.encode(key);

    final decrypted = List<int>.generate(
      encryptedBytes.length,
          (i) => encryptedBytes[i] ^ keyBytes[i % keyBytes.length],
    );

    return utf8.decode(decrypted);
  }

  static Future<bool> saveData(String key, dynamic value) async {
    try {
      if (value is String) {
        return await sharedPreferences.setString(key, _xorEncrypt(value, key));
      } else if (value is double) {
        return await sharedPreferences.setDouble(key, value);
      } else if (value is bool) {
        return await sharedPreferences.setBool(key, value);
      } else if (value is int) {
        return await sharedPreferences.setInt(key, value);
      } else if (value is List<String>) {
        return await sharedPreferences.setStringList(key, value);
      } else if (value is Map<String, dynamic>) {
        final jsonStr = json.encode(value);
        return await sharedPreferences.setString(key, _xorEncrypt(jsonStr, key));
      }
      throw Exception('Unsupported data type');
    } catch (e) {
      print('CacheHelper::saveData error → $e');
      return false;
    }
  }

  static dynamic getData(String key) {
    final value = sharedPreferences.get(key);
    if (value is String) {
      try {
        return _xorDecrypt(value, key);
      } catch (_) {
        return value;
      }
    }
    return value;
  }

  static bool getBool(String key) => sharedPreferences.getBool(key) ?? false;

  static Future<bool> removeData(String key) async =>
      await sharedPreferences.remove(key);

  static Future<bool> clearData() async =>
      await sharedPreferences.clear();
}
