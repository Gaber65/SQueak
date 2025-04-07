import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }



  static String xorEncryptDecrypt(String data, String key) {
    List<int> dataBytes = utf8.encode(data);
    List<int> keyBytes = utf8.encode(key);

    List<int> encryptedBytes = [];
    for (int i = 0; i < dataBytes.length; i++) {
      encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64.encode(encryptedBytes);
  }

  static String xorDecrypt(String encryptedData, String key) {
    List<int> encryptedBytes = base64.decode(encryptedData);
    List<int> keyBytes = utf8.encode(key);

    List<int> decryptedBytes = [];
    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return utf8.decode(decryptedBytes);
  }

  static Future<bool> saveData(String key, dynamic value,) async {
    try {
      if (value is String) {
        String encryptedValue = xorEncryptDecrypt(value, key);
        return await sharedPreferences.setString(key, encryptedValue);
      } else if (value is double) {
        return await sharedPreferences.setDouble(key, value);
      } else if (value is bool) {
        return await sharedPreferences.setBool(key, value);
      } else if (value is int) {
        return await sharedPreferences.setInt(key, value);
      } else if (value is List<String>) {
        return await sharedPreferences.setStringList(key, value);
      } else if (value is Map<String, dynamic>) {
        String encryptedValue = xorEncryptDecrypt(json.encode(value), key);
        return await sharedPreferences.setString(key, encryptedValue);
      }
      throw Exception('Unsupported data type');
    } catch (e) {
      print('Failed to save data: $e');
      return false;
    }
  }

  static dynamic getData(String key) {
    dynamic value = sharedPreferences.get(key);
    if (value is String) {
      return xorDecrypt(value, key);
    }
    return value;
  }

  static bool getBool(String key) {
    return sharedPreferences.getBool(key) ?? false;
  }

  static Future<bool> removeData(String key) async {
    return await sharedPreferences.remove(key);
  }

  static Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }
}
