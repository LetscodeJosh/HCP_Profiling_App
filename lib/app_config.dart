enum AppMode {
  hcp,
}

enum Environment {
  development,
  staging,
  production,
}

class AppConfig {
  static AppMode mode = AppMode.hcp;

  // ===========================================================================
  // 🚀 SERVER ENVIRONMENT SWITCH (SINGLE-LINE TOGGLE)
  // Set to Environment.development, Environment.staging, or Environment.production
  // ===========================================================================
  static Environment environment = Environment.development;

  // Development Server URL
  static const String devServerUrl = 'https://dev.pmii-marketing.com';

  // Staging Server URL
  static const String stagingServerUrl = 'https://staging.pmii-marketing.com';

  // Production Server URL
  static const String prodServerUrl = 'https://hris.pmii-marketing.com';

  /// Active server URL determined dynamically by the environment setting
  static String get serverUrl {
    switch (environment) {
      case Environment.development:
        return devServerUrl;
      case Environment.staging:
        return stagingServerUrl;
      case Environment.production:
        return prodServerUrl;
    }
  }
}

