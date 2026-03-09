import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/match_models.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../data/leaderboard_repository.dart';


class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  // Default to the completed tournament for demo
  final String _selectedTournamentId = 'trn_005';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaderboardAsync =
        ref.watch(leaderboardProvider(_selectedTournamentId));

    return Scaffold(
      appBar: AppBar(
        title: Text('LEADERBOARD', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.secondary),
            onPressed: () =>
                ref.invalidate(leaderboardProvider(_selectedTournamentId)),
          ),
        ],
      ),
      body: MeshBackground(
        child: leaderboardAsync.when(
          loading: () => Padding(
            padding: const EdgeInsets.all(16),
            child: LoadingShimmer.list(count: 8, itemHeight: 60),
          ),
          error: (e, _) => ErrorState(
            message: e.toString(),
            onRetry: () =>
                ref.invalidate(leaderboardProvider(_selectedTournamentId)),
          ),
          data: (results) {
            if (results.isEmpty) {
              return const EmptyState(
                icon: Icons.leaderboard_outlined,
                title: 'No results yet',
                subtitle: 'Results will appear after the match ends',
              );
            }

            return CustomScrollView(
              slivers: [
                // Top 3 podium
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildPodium(results, theme),
                  ),
                ),

                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withAlpha(20),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.glassBorderCyan),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 36,
                                child: Text('#',
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w900, fontSize: 12))),
                            Expanded(
                                flex: 3,
                                child: Text('PLAYER',
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w900, fontSize: 12))),
                            Expanded(
                                child: Text('KILLS',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w900, fontSize: 12))),
                            Expanded(
                                child: Text('POS',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w900, fontSize: 12))),
                            Expanded(
                                child: Text('PTS',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900, fontSize: 12))),
                          ],
                        ),
                      ),
                  ),
                ),

                // Result rows
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final result = results[index];
                        final rank = index + 1;
                        return _ResultRow(
                            result: result, rank: rank);
                      },
                      childCount: results.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPodium(
      List<MatchResult> results, ThemeData theme) {
    if (results.length < 3) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _PodiumCard(
            result: results[1],
            rank: 2,
            height: 140,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 12),
          // 1st place
          _PodiumCard(
            result: results[0],
            rank: 1,
            height: 180,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          // 3rd place
          _PodiumCard(
            result: results[2],
            rank: 3,
            height: 120,
            color: const Color(0xFFCD7F32),
          ),
        ],
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  final MatchResult result;
  final int rank;
  final double height;
  final Color color;

  const _PodiumCard({
    required this.result,
    required this.rank,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 100,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Crown for 1st
          if (rank == 1)
            const Icon(Icons.workspace_premium,
                color: AppColors.accent, size: 28),
          // Avatar
          CircleAvatar(
            radius: rank == 1 ? 28 : 22,
            backgroundColor: color.withAlpha(60),
            child: Text(
              result.username.substring(0, 2).toUpperCase(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: rank == 1 ? 16 : 13,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result.username,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${result.totalPoints.toStringAsFixed(0)} pts',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          // Podium base
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withAlpha(80), color.withAlpha(20)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30)),
                border: Border.all(color: color.withAlpha(100)),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(40),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '#$rank',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: rank == 1 ? 24 : 18,
                    shadows: [
                      Shadow(color: color, blurRadius: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final MatchResult result;
  final int rank;

  const _ResultRow({
    required this.result,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTop3 = rank <= 3;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 15,
      showBlur: false, // Don't blur individual rows to keep list performance
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: isTop3 ? AppColors.primary : Colors.white70,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary.withAlpha(30),
                  child: Text(
                    result.username.substring(0, 1),
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.username,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${result.kills}',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              '#${result.placement}',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              result.totalPoints.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
