import '../utils/enums/env_enums.dart';

class ConfigModel {
  static late String serverFirstHalfOfImageUrl;
  static late String baseApiUrlSqueak;

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.test:
        serverFirstHalfOfImageUrl =
            'https://veticareapi.veticareapp.com:8002/files/';
        baseApiUrlSqueak = 'https://squeakapi.veticareapp.com:8001';
        break;
      case Environment.pre:
        serverFirstHalfOfImageUrl = 'https://vicapiub.veticareapp.com/files/';
        baseApiUrlSqueak = 'https://squeakapipro.veticareapp.com';
        break;
      case Environment.pro:
        serverFirstHalfOfImageUrl = 'https://vicapipro.veticareapp.com/files/';
        baseApiUrlSqueak = 'https://squeakapipro.veticareapp.com';
        break;
    }
  }
}
