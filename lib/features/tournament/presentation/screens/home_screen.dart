import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/providers/live_status_provider.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../domain/tournament_provider.dart';
import '../widgets/tournament_card.dart';
import '../widgets/tournament_filter_bar.dart';
import '../../../../shared/widgets/mesh_background.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tourState = ref.watch(tournamentListProvider);
    final notifier = ref.read(tournamentListProvider.notifier);
    final padding = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            Image.network(
              'https://wesquare.com/logo.png', // Placeholder or use icon if no image
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.grid_3x3, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 12),
            Text('WeSquare', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_outlined, color: AppColors.secondary),
            tooltip: 'Find a Squad',
            onPressed: () => context.push('/home/squads'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.secondary),
            onPressed: () => context.push('/home/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: MeshBackground(
        child: RefreshIndicator(
          onRefresh: () => notifier.loadTournaments(),
          child: CustomScrollView(

          slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, 24, padding, 16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.glassBg,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.glassBorder.withAlpha(50)),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => notifier.setSearch(v),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: AppColors.textHint.withAlpha(150), fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
                    ),
                  ),
                ),
              ),
            ),


            // Filter bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TournamentFilterBar(
                  selectedStatus: tourState.statusFilter,
                  selectedMaxFee: tourState.maxEntryFeeFilter,
                  onStatusChanged: (s) => notifier.setStatusFilter(s),
                  onMaxFeeChanged: (f) => notifier.setMaxEntryFee(f),
                  onClearFilters: () {
                    _searchCtrl.clear();
                    notifier.clearFilters();
                  },
                ),
              ),
            ),

            // ─── Live Activity Ticker ──────────
            Consumer(
              builder: (context, ref, _) {
                final liveState = ref.watch(liveStatusProvider);
                if (liveState.notifications.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                final latest = liveState.notifications.first;
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        key: ValueKey(latest.timestamp),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.success.withAlpha(20),
                              AppColors.secondary.withAlpha(10),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.success.withAlpha(30)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.success.withAlpha(150),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                latest.message,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Section header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, 16, padding, 12),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('ACTIVE TOURNAMENTS',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppColors.textPrimary)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${tourState.tournaments.length} MATCHES',
                        style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            // Content
            if (tourState.isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: LoadingShimmer.list(),
                ),
              )
            else if (tourState.error != null)
              SliverToBoxAdapter(
                child: ErrorState(
                  message: tourState.error!,
                  onRetry: () => notifier.loadTournaments(),
                ),
              )
            else if (tourState.tournaments.isEmpty)
              const SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.emoji_events_outlined,
                  title: 'No tournaments found',
                  subtitle: 'Try adjusting your filters or check back later',
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final columns = Responsive.gridColumns(context);
                    if (columns > 1) {
                      // Grid for tablet/desktop
                      return SliverGrid(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 450, // Max width per card
                          mainAxisExtent: 230, // Fixed height to prevent overflow
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final t = tourState.tournaments[index];
                            return TournamentCard(
                              tournament: t,
                              onTap: () =>
                                  context.push('/tournament/${t.id}'),
                            );
                          },
                          childCount: tourState.tournaments.length,
                        ),
                      );
                    }
                    // List for mobile
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final t = tourState.tournaments[index];
                          return TournamentCard(
                            tournament: t,
                            onTap: () =>
                                context.push('/tournament/${t.id}'),
                          );
                        },

                        childCount: tourState.tournaments.length,
                      ),
                    );
                  },
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    ),
    );
  }

}
