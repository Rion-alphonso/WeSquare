/// All API endpoint paths used in the app
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // User / Profile
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String uploadAvatar = '/user/avatar';
  static const String matchHistory = '/user/match-history';

  // Tournament
  static const String tournaments = '/tournaments';
  static String tournamentById(String id) => '/tournaments/$id';
  static String joinTournament(String id) => '/tournaments/$id/join';
  static String roomDetails(String id) => '/tournaments/$id/room';

  // Wallet
  static const String walletBalance = '/wallet/balance';
  static const String walletTransactions = '/wallet/transactions';
  static const String addMoney = '/wallet/add';
  static const String withdraw = '/wallet/withdraw';
  static const String withdrawRequests = '/wallet/withdraw/requests';

  // Leaderboard
  static String leaderboard(String tournamentId) =>
      '/tournaments/$tournamentId/leaderboard';

  // Screenshot
  static String uploadScreenshot(String tournamentId) =>
      '/tournaments/$tournamentId/screenshot';

  // KYC
  static const String kycUpload = '/kyc/upload';
  static const String kycStatus = '/kyc/status';

  // Notifications
  static const String notifications = '/notifications';
  static const String registerFcmToken = '/notifications/register';

  // Admin
  static const String adminTournaments = '/admin/tournaments';
  static const String adminScreenshots = '/admin/screenshots';
  static const String adminWithdrawals = '/admin/withdrawals';
  static const String adminKyc = '/admin/kyc';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminUsers = '/admin/users';
}
