import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/wallet_transaction_model.dart';
import '../data/wallet_repository.dart';

/// Wallet state
class WalletState {
  final double balance;
  final List<WalletTransaction> transactions;
  final bool isLoading;
  final String? error;

  const WalletState({
    this.balance = 0.0,
    this.transactions = const [],
    this.isLoading = false,
    this.error,
  });

  WalletState copyWith({
    double? balance,
    List<WalletTransaction>? transactions,
    bool? isLoading,
    String? error,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Wallet state notifier
class WalletNotifier extends StateNotifier<WalletState> {
  final WalletRepository _repository;

  WalletNotifier(this._repository) : super(const WalletState()) {
    loadWallet();
  }

  Future<void> loadWallet() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final balance = await _repository.getBalance();
      final transactions = await _repository.getTransactions();
      state = WalletState(
        balance: balance,
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addMoney(double amount) async {
    try {
      final success = await _repository.addMoney(amount);
      if (success) {
        state = state.copyWith(balance: state.balance + amount);
        await loadWallet(); // Reload full state
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> requestWithdrawal({
    required double amount,
    required String upiId,
  }) async {
    try {
      final success = await _repository.requestWithdrawal(
        amount: amount,
        upiId: upiId,
      );
      if (success) {
        state = state.copyWith(balance: state.balance - amount);
        await loadWallet();
      }
      return success;
    } catch (_) {
      return false;
    }
  }
}

/// Provider
final walletProvider =
    StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(ref.watch(walletRepositoryProvider));
});
