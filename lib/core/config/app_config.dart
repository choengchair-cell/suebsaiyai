enum AppEnvironment { development, staging, production }

class AppConfig {
  const AppConfig._({
    required this.environment,
    required this.claudeApiBaseUrl,
    required this.enableLogging,
    required this.enableCrashReporting,
  });

  final AppEnvironment environment;
  final String claudeApiBaseUrl;
  final bool enableLogging;
  final bool enableCrashReporting;

  static AppConfig? _instance;

  static AppConfig get instance {
    assert(_instance != null, 'AppConfig must be initialized before use');
    return _instance!;
  }

  static void initialize(AppEnvironment env) {
    _instance = AppConfig._(
      environment: env,
      claudeApiBaseUrl: 'https://api.anthropic.com/v1',
      enableLogging: env != AppEnvironment.production,
      enableCrashReporting: env == AppEnvironment.production,
    );
  }

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isProduction => environment == AppEnvironment.production;
}
