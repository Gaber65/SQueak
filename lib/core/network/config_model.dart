import '../utils/enums/env_enums.dart';

class ConfigModel {
  static late String serverFirstHalfOfImageUrl;
  static late String baseApiUrlSqueak;
  static late String serverClientIdGoogle;
  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.test:
        serverFirstHalfOfImageUrl =
            'https://veticareapi.veticareapp.com:8002/files/';
        baseApiUrlSqueak = 'https://squeakapi.veticareapp.com:8001';
        serverClientIdGoogle = "205107241099-pu6b4gf1jfqmsjehbpj1s43mqj6svsus.apps.googleusercontent.com";
        break;
      case Environment.pre:
        serverFirstHalfOfImageUrl = 'https://vicapiub.veticareapp.com/files/';
        baseApiUrlSqueak = 'https://squeakapipro.veticareapp.com';
        serverClientIdGoogle =
            "205107241099-pu6b4gf1jfqmsjehbpj1s43mqj6svsus.apps.googleusercontent.com";

        break;
      case Environment.pro:
        serverFirstHalfOfImageUrl = 'https://vicapipro.veticareapp.com/files/';
        baseApiUrlSqueak = 'https://squeakapipro.veticareapp.com';
        serverClientIdGoogle =
            "205107241099-pu6b4gf1jfqmsjehbpj1s43mqj6svsus.apps.googleusercontent.com";

        break;
    }
  }
}
