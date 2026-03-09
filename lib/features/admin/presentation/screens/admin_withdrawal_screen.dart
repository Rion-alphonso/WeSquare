import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../core/constants/app_colors.dart';



class AdminWithdrawalScreen extends ConsumerWidget {
  const AdminWithdrawalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('WITHDRAWAL REQUESTS', style: theme.textTheme.headlineSmall),
      ),
      body: MeshBackground(
        child: ListView.builder(

        padding: const EdgeInsets.all(16),
        itemCount: _mockWithdrawals.length,
        itemBuilder: (ctx, i) {
          final w = _mockWithdrawals[i];
          return AppCard(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            borderRadius: 18,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.secondary, width: 1.5),
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.secondary.withAlpha(20),
                        child: Text(
                          w['user']!.substring(0, 1),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w['user']!.toUpperCase(), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                          Text('UPI: ${w['upi']}',
                              style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Text(
                      '₹${w['amount']}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                        shadows: [BoxShadow(color: AppColors.secondaryGlow, blurRadius: 10)],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: AppColors.glassBorder),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(w['date']!, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    if (w['status'] == 'pending') ...[
                      AppButton(
                        text: 'REJECT',
                        isOutlined: true,
                        height: 32,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Withdrawal rejected'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      AppButton(
                        text: 'APPROVE',
                        useGradient: true,
                        height: 32,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Withdrawal approved ✅'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ] else
                      _statusBadge(w['status']!),
                  ],
                ),

              ],
            ),
          );
        },
      ),
    ),
    );
  }


  Widget _statusBadge(String status) {
    final color = status == 'approved' ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

}

const _mockWithdrawals = [
  {'user': 'SniperKing99', 'amount': '500', 'upi': 'sniper@paytm', 'date': '24 Feb, 2:30 PM', 'status': 'pending'},
  {'user': 'ProPlayer_Mk47', 'amount': '1200', 'upi': 'pro@gpay', 'date': '24 Feb, 1:15 PM', 'status': 'pending'},
  {'user': 'BattleRoyaleQueen', 'amount': '800', 'upi': 'queen@upi', 'date': '23 Feb, 5:00 PM', 'status': 'approved'},
  {'user': 'RushGamer2024', 'amount': '300', 'upi': 'rush@bank', 'date': '23 Feb, 11:00 AM', 'status': 'rejected'},
];
