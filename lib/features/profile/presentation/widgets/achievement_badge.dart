import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/user_model.dart';
import '../../../../shared/widgets/app_card.dart';

/// Grid of achievement badges with locked/unlocked states
class AchievementBadgeGrid extends StatelessWidget {
  final List<AchievementBadgeData> badges;
  const AchievementBadgeGrid({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlocked = badges.where((b) => b.unlocked).length;

    return AppCard(
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.military_tech, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text(
                'ACHIEVEMENTS',
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 2.0,
                  color: AppColors.secondary,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unlocked/${badges.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return _BadgeTile(badge: badge);
            },
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final AchievementBadgeData badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showBadgeDetail(context),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: badge.unlocked ? 1.0 : 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.unlocked
                    ? AppColors.secondary.withAlpha(20)
                    : AppColors.glassBg,
                border: Border.all(
                  color: badge.unlocked
                      ? AppColors.secondary.withAlpha(60)
                      : AppColors.glassBorder,
                  width: 1.5,
                ),
                boxShadow: badge.unlocked
                    ? [
                        BoxShadow(
                          color: AppColors.secondaryGlow,
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: badge.unlocked
                    ? Text(badge.icon, style: const TextStyle(fontSize: 22))
                    : const Icon(Icons.lock_outline,
                        size: 18, color: AppColors.textHint),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 8,
                color: badge.unlocked ? Colors.white : AppColors.textHint,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.glassBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.unlocked
                    ? AppColors.secondary.withAlpha(20)
                    : AppColors.glassBg,
                border: Border.all(
                  color: badge.unlocked
                      ? AppColors.secondary
                      : AppColors.glassBorder,
                  width: 2,
                ),
              ),
              child: Center(
                child: badge.unlocked
                    ? Text(badge.icon, style: const TextStyle(fontSize: 36))
                    : const Icon(Icons.lock_outline,
                        size: 32, color: AppColors.textHint),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              badge.name.toUpperCase(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: badge.unlocked ? Colors.white : AppColors.textHint,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            if (badge.unlocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success.withAlpha(40)),
                ),
                child: Text(
                  '✓ UNLOCKED',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.textHint.withAlpha(15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: const Text(
                  '🔒 LOCKED',
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
