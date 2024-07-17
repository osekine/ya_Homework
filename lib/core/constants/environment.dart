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
  static late String apiKey;
  static late String baseUrl;
}
