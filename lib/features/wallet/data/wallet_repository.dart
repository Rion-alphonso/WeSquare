import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/wallet_transaction_model.dart';
import '../../../core/network/api_client.dart';

/// Wallet repository provider
final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(apiClient: ref.watch(apiClientProvider));
});

/// Repository for wallet operations
class WalletRepository {
  final ApiClient apiClient;

  WalletRepository({required this.apiClient});

  /// Get current balance
  Future<double> getBalance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 1250.0;
  }

  /// Get transaction history
  Future<List<WalletTransaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return WalletTransaction.mockList();
  }

  /// Add money (Razorpay stub)
  Future<bool> addMoney(double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  /// Request withdrawal
  Future<bool> requestWithdrawal({
    required double amount,
    required String upiId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
