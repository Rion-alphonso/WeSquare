import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/secure_storage_service.dart';

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

/// Repository handling all authentication operations
class AuthRepository {
  final ApiClient apiClient;
  final SecureStorageService storage;

  AuthRepository({required this.apiClient, required this.storage});

  /// Email/password login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // TODO: Replace with real API call
    // final response = await apiClient.post(ApiEndpoints.login, data: {
    //   'email': email,
    //   'password': password,
    // });
    // await storage.saveToken(response.data['token']);
    // await storage.saveRefreshToken(response.data['refreshToken']);
    // return UserModel.fromJson(response.data['user']);

    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    final user = email.contains('admin')
        ? UserModel.mockAdmin()
        : UserModel.mock();
    await storage.saveToken('mock_jwt_token_${user.id}');
    await storage.saveRefreshToken('mock_refresh_token_${user.id}');
    await storage.saveUserData(jsonEncode(user.toJson()));
    return user;
  }

  /// Register new user
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    String? phone,
    String? referralCode,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = UserModel(
      id: 'usr_new_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      phone: phone,
      createdAt: DateTime.now(),
    );
    await storage.saveToken('mock_jwt_token_${user.id}');
    await storage.saveRefreshToken('mock_refresh_token_${user.id}');
    await storage.saveUserData(jsonEncode(user.toJson()));
    return user;
  }

  /// Send OTP for phone login
  Future<bool> sendOtp({required String phone}) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Verify OTP and login
  Future<UserModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = UserModel.mock().copyWith(phone: phone);
    await storage.saveToken('mock_jwt_token_${user.id}');
    await storage.saveRefreshToken('mock_refresh_token_${user.id}');
    await storage.saveUserData(jsonEncode(user.toJson()));
    return user;
  }

  /// Try to auto-login from stored token
  Future<UserModel?> tryAutoLogin() async {
    final token = await storage.getToken();
    if (token == null) return null;

    final userData = await storage.getUserData();
    if (userData == null) return null;

    try {
      return UserModel.fromJson(jsonDecode(userData) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    // TODO: Call API to invalidate token
    await storage.clearAll();
  }
}
