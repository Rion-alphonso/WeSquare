import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';




class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final columns = Responsive.gridColumns(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('ADMIN CONSOLE', style: theme.textTheme.headlineSmall),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: AppColors.secondary), onPressed: () {}),
        ],
      ),
      body: MeshBackground(
        child: SingleChildScrollView(

        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Stats Grid ──────────────────
            Text('ANALYTICS OVERVIEW', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.textSecondary)),

            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: columns.clamp(2, 3),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: const [
                _StatCard(
                  icon: Icons.people,
                  title: 'Total Users',
                  value: '12,485',
                  change: '+342 this week',
                  changePositive: true,
                  color: AppColors.primary,
                ),
                _StatCard(
                  icon: Icons.currency_rupee,
                  title: 'Total Revenue',
                  value: '₹8,45,200',
                  change: '+₹45,000 today',
                  changePositive: true,
                  color: AppColors.success,
                ),
                _StatCard(
                  icon: Icons.percent,
                  title: 'Commission',
                  value: '₹1,26,780',
                  change: '15% of revenue',
                  changePositive: true,
                  color: AppColors.accent,
                ),
                _StatCard(
                  icon: Icons.emoji_events,
                  title: 'Active Tournaments',
                  value: '24',
                  change: '5 starting today',
                  changePositive: true,
                  color: AppColors.info,
                ),
                _StatCard(
                  icon: Icons.account_balance_wallet,
                  title: 'Pending Withdrawals',
                  value: '₹32,100',
                  change: '18 requests',
                  changePositive: false,
                  color: AppColors.warning,
                ),
                _StatCard(
                  icon: Icons.flag,
                  title: 'Fraud Flags',
                  value: '3',
                  change: 'Needs review',
                  changePositive: false,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ─── Recent Activity ──────────────
            Text('REAL-TIME ACTIVITY', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.textSecondary)),

            const SizedBox(height: 12),
            ..._mockActivities.map((a) => _ActivityTile(
                  icon: a.icon,
                  title: a.title,
                  subtitle: a.subtitle,
                  time: a.time,
                  color: a.color,
                )),
            const SizedBox(height: 24),

            // ─── Quick Actions ─────────────────
            Text('SYSTEM CONTROLS', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5, color: AppColors.textSecondary)),

            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickAction(
                  icon: Icons.add_circle,
                  label: 'Create Tournament',
                  color: AppColors.primary,
                  onTap: () {},
                ),
                _QuickAction(
                  icon: Icons.vpn_key,
                  label: 'Set Room ID',
                  color: AppColors.success,
                  onTap: () {},
                ),
                _QuickAction(
                  icon: Icons.screenshot,
                  label: 'Review Screenshots',
                  color: AppColors.info,
                  onTap: () {},
                ),
                _QuickAction(
                  icon: Icons.payments,
                  label: 'Approve Withdrawals',
                  color: AppColors.warning,
                  onTap: () {},
                ),
                _QuickAction(
                  icon: Icons.grid_view_rounded,
                  label: 'Bulk Verify',
                  color: AppColors.secondary,
                  onTap: () => context.push('/admin/bulk-verify'),
                ),
                _QuickAction(
                  icon: Icons.account_balance,
                  label: 'Mass Payouts',
                  color: AppColors.success,
                  onTap: () => context.push('/admin/mass-payouts'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String change;
  final bool changePositive;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.changePositive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withAlpha(50)),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: (changePositive ? AppColors.success : AppColors.error).withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  changePositive ? Icons.trending_up : Icons.trending_down,
                  color: changePositive ? AppColors.success : AppColors.error,
                  size: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w800, fontSize: 9, letterSpacing: 1)),
          Text(value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: color == AppColors.primary ? AppColors.primary : (color == AppColors.success ? AppColors.success : AppColors.secondary),
                shadows: [BoxShadow(color: color.withAlpha(100), blurRadius: 10)],
              )),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: changePositive ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}


class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      borderRadius: 12,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withAlpha(50)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w800)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(time, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}


class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(30)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                )),
          ],
        ),
      ),
    );
  }
}

// Mock activity data
class _ActivityData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}

const _mockActivities = [
  _ActivityData(
    icon: Icons.person_add,
    title: 'New user registered',
    subtitle: 'ProPlayer_Mk47 joined the platform',
    time: '2m ago',
    color: AppColors.primary,
  ),
  _ActivityData(
    icon: Icons.emoji_events,
    title: 'Tournament completed',
    subtitle: 'WeSquare Classic #42 — 96 players',
    time: '15m ago',
    color: AppColors.success,
  ),
  _ActivityData(
    icon: Icons.account_balance_wallet,
    title: 'Withdrawal requested',
    subtitle: '₹500 by SniperKing99',
    time: '32m ago',
    color: AppColors.warning,
  ),
  _ActivityData(
    icon: Icons.flag,
    title: 'Fraud flag raised',
    subtitle: 'Suspicious screenshot from match #78',
    time: '1h ago',
    color: AppColors.error,
  ),
  _ActivityData(
    icon: Icons.verified_user,
    title: 'KYC submitted',
    subtitle: 'BattleRoyaleQueen submitted documents',
    time: '2h ago',
    color: AppColors.info,
  ),
];
