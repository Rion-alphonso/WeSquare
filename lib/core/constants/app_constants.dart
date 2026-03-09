/// App-wide constants
class AppConstants {
  AppConstants._();

  // Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration pollingInterval = Duration(seconds: 10);
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);

  // Pagination
  static const int pageSize = 20;

  // Wallet
  static const double minDepositAmount = 10.0;
  static const double maxDepositAmount = 50000.0;
  static const double minWithdrawAmount = 50.0;

  // Image
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int imageQuality = 70;

  // Validation
  static const int otpLength = 6;
  static const int minPasswordLength = 8;
  static const int maxUsernameLength = 20;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Asset Paths
  static const String logoPath = 'assets/images/logo.png';
  static const String emptyStatePath = 'assets/images/empty.png';
  static const String errorStatePath = 'assets/images/error.png';
}
