class EnvironmentDefines {
  static const bool isDev = bool.fromEnvironment('DEFINE_IS_DEV');
  static const String appSuffix = String.fromEnvironment('DEFINE_APP_SUFFIX');
  static const String appName = String.fromEnvironment('DEFINE_APP_NAME');
  static const String appVersion = String.fromEnvironment('DEFINE_APP_VERSION');
}
