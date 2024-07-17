import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/logs.dart';

class EnvironmentDefines {
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: 'lib/.env');
      apiKey = const String.fromEnvironment('DEFINE_API_KEY') == ''
          ? dotenv.get('API_KEY')
          : const String.fromEnvironment('DEFINE_API_KEY');
      baseUrl = const String.fromEnvironment('DEFINE_BASE_URL') == ''
          ? dotenv.get('BASE_URL')
          : const String.fromEnvironment('DEFINE_BASE_URL');
    } catch (e) {
      Logs.log('$e');
    }

    return Future.value();
  }

  static const bool isDev = bool.fromEnvironment('DEFINE_IS_DEV');
  static const String appSuffix = String.fromEnvironment('DEFINE_APP_SUFFIX');
  static const String appName = String.fromEnvironment('DEFINE_APP_NAME');
  static const String appVersion = String.fromEnvironment('DEFINE_APP_VERSION');
  static const String fireBaseAndroidApiKey =
      String.fromEnvironment('DEFINE_FIREBASE_ANDROID_API_KEY');
  static const String fireBaseWebApiKey =
      String.fromEnvironment('DEFINE_FIREBASE_WEB_API_KEY');
  static const String fireBaseIosApiKey =
      String.fromEnvironment('DEFINE_FIREBASE_IOS_API_KEY');
  static const String fireBaseAppId =
      String.fromEnvironment('DEFINE_FIREBASE_APP_ID');
  static late String apiKey;
  static late String baseUrl;
}
