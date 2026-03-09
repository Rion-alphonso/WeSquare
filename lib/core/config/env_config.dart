/// Environment configuration for dev/prod switching
enum Environment { dev, prod }

class EnvConfig {
  static late Environment _environment;

  static void init(Environment env) {
    _environment = env;
  }

  static Environment get environment => _environment;
  static bool get isDev => _environment == Environment.dev;
  static bool get isProd => _environment == Environment.prod;

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://dev-api.wesquare.com/api/v1';
      case Environment.prod:
        return 'https://api.wesquare.com/api/v1';
    }
  }

  static String get razorpayKey {
    switch (_environment) {
      case Environment.dev:
        return 'rzp_test_XXXXXXXXXXXXXXX';
      case Environment.prod:
        return 'rzp_live_XXXXXXXXXXXXXXX';
    }
  }

  static String get appName => 'WeSquare';
  static String get supportEmail => 'support@wesquare.com';
}
