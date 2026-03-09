import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/user_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../auth/domain/auth_provider.dart';
import '../widgets/profile_stats.dart';
import '../widgets/achievement_badge.dart';

import '../../../../main.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final authState = ref.watch(authProvider);
    final user = authState.user ?? UserModel.mock();
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('PROFILE', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: AppColors.secondary,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: MeshBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
            const SizedBox(height: 20),
            // ─── Profile Header ──────────────────
            AppCard(
              borderRadius: 30,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.darkBg,
                          backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                          child: user.avatarUrl == null
                              ? Text(user.username.substring(0, 2).toUpperCase(),
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white))
                              : null,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.secondaryGlow, blurRadius: 10)],
                        ),
                        child: const Icon(Icons.edit, size: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(user.username.toUpperCase(),
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  Text(user.email, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.secondary)),
                  const SizedBox(height: 12),
                  // Level badge inline
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'LEVEL ${user.level}  ⚡',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _KycBadge(status: user.kycStatus),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Gamification: Stats ──────────────
            ProfileStats(user: user),
            const SizedBox(height: 24),

            // ─── Gamification: Badges ─────────────
            AchievementBadgeGrid(badges: user.badges),
            const SizedBox(height: 24),

            // Wallet Section
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              borderRadius: 20,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WALLET BALANCE', style: theme.textTheme.labelLarge?.copyWith(fontSize: 10, color: AppColors.textHint)),
                      Text('₹${user.walletBalance.toStringAsFixed(2)}',
                          style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const Spacer(),
                  AppButton(
                    text: 'ADD',
                    width: 70,
                    height: 36,
                    useGradient: true,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─── Menu Options ──────────────────
            _MenuTile(
              icon: Icons.edit,
              title: 'EDIT PROFILE',
              subtitle: 'Update your gamer details',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.history,
              title: 'MATCH HISTORY',
              subtitle: 'View your performance',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.verified_user,
              title: 'KYC VERIFICATION',
              subtitle: user.kycStatus == KycStatus.approved
                  ? 'VERIFIED'
                  : 'PENDING ACTION',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.card_giftcard,
              title: 'REFERRAL CODE',
              subtitle: user.referralCode ?? 'NONE',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.help_outline,
              title: 'SUPPORT',
              subtitle: 'Get help safely',
              onTap: () {},
            ),
            const SizedBox(height: 24),


            // ─── Logout ──────────────────────
            AppButton(
              text: 'Logout',
              isOutlined: true,
              icon: Icons.logout,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ref.read(authProvider.notifier).logout();
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

}

class _KycBadge extends StatelessWidget {
  final KycStatus status;
  const _KycBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case KycStatus.approved:
        color = AppColors.success;
        label = 'KYC Verified';
        icon = Icons.verified;
        break;
      case KycStatus.pending:
        color = AppColors.warning;
        label = 'KYC Pending';
        icon = Icons.hourglass_top;
        break;
      case KycStatus.rejected:
        color = AppColors.error;
        label = 'KYC Rejected';
        icon = Icons.cancel;
        break;
      case KycStatus.notSubmitted:
        color = AppColors.darkTextHint;
        label = 'KYC Not Submitted';
        icon = Icons.upload_file;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label.toUpperCase(),
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
        ],
      ),
    );

  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return AppCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 15,
      showBlur: false,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.secondary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textHint), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.textHint, size: 14),
        ],
      ),
    );

  }
}


