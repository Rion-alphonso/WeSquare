import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/user_model.dart';
import '../../../../shared/widgets/app_card.dart';

/// Radial XP progress + stats grid for the Profile screen
class ProfileStats extends StatelessWidget {
  final UserModel user;
  const ProfileStats({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ─── Level / XP Radial ──────────────────────
        AppCard(
          borderRadius: 24,
          child: Column(
            children: [
              Text(
                'PLAYER RANK',
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 2.0,
                  color: AppColors.secondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 16),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 8.0,
                percent: user.xpProgress.clamp(0.0, 1.0),
                animation: true,
                animationDuration: 1200,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LVL',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                        letterSpacing: 2.0,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '${user.level}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                linearGradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                backgroundColor: AppColors.glassBg,
              ),
              const SizedBox(height: 12),
              Text(
                '${user.xp} / ${user.xpToNextLevel} XP',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textHint,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: user.xpProgress.clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: AppColors.glassBg,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ─── Stats Grid ──────────────────────────────
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'WIN RATE',
                value: '${user.winRate.toStringAsFixed(1)}%',
                icon: Icons.emoji_events_outlined,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'K/D RATIO',
                value: user.kdRatio.toStringAsFixed(1),
                icon: Icons.track_changes,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'MATCHES',
                value: '${user.matchesPlayed}',
                icon: Icons.sports_esports_outlined,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'TOTAL KILLS',
                value: '${user.totalKills}',
                icon: Icons.whatshot_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      showBlur: false,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textHint,
              letterSpacing: 1.2,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
