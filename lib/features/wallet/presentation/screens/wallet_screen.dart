import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../core/models/wallet_transaction_model.dart';
import '../../domain/wallet_provider.dart';
import 'package:intl/intl.dart';


class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('WALLET', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => context.pop(),
        ),
      ),
      body: MeshBackground(
        child: walletState.isLoading
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: LoadingShimmer.list(count: 4, itemHeight: 80),
            )
          : RefreshIndicator(
              onRefresh: () => ref.read(walletProvider.notifier).loadWallet(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Balance Card
                        AppCard(
                          borderRadius: 20,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('AVAILABLE BALANCE',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                  )),
                              const SizedBox(height: 12),
                              Text(
                                '₹${walletState.balance.toStringAsFixed(2)}',
                                style: theme.textTheme.displayMedium?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    BoxShadow(color: AppColors.secondaryGlow, blurRadius: 20),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      text: 'ADD MONEY',
                                      useGradient: true,
                                      height: 48,
                                      onPressed: () => context.push('/wallet/add'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: AppButton(
                                      text: 'WITHDRAW',
                                      isOutlined: true,
                                      height: 48,
                                      onPressed: () => context.push('/wallet/withdraw'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('TRANSACTION HISTORY',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                        const SizedBox(height: 12),
                        if (walletState.transactions.isEmpty)
                          const EmptyState(
                            icon: Icons.receipt_long_outlined,
                            title: 'No transactions yet',
                            subtitle: 'Add money to start playing',
                          )
                        else
                          ...walletState.transactions.map((txn) =>
                              _TransactionTile(transaction: txn)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCredit = transaction.isCredit;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isCredit ? AppColors.success : AppColors.error).withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (isCredit ? AppColors.success : AppColors.error).withAlpha(50)),
            ),
            child: Icon(
              isCredit ? Icons.add_circle_outline : Icons.remove_circle_outline,
              color: isCredit ? AppColors.success : AppColors.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.description.toUpperCase(),
                    style: theme.textTheme.titleSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM, HH:mm').format(transaction.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'} ₹${transaction.amount.toStringAsFixed(0)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isCredit ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (transaction.status == TransactionStatus.pending)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withAlpha(20),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.warning.withAlpha(50)),
                  ),
                  child: const Text(
                    'PENDING',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
