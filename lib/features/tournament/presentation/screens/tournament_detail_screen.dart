import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/tournament_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/tournament_repository.dart';
import '../../domain/tournament_provider.dart';
import '../../../wallet/domain/wallet_provider.dart';


class TournamentDetailScreen extends ConsumerStatefulWidget {
  final String tournamentId;
  const TournamentDetailScreen({super.key, required this.tournamentId});

  @override
  ConsumerState<TournamentDetailScreen> createState() =>
      _TournamentDetailScreenState();
}

class _TournamentDetailScreenState
    extends ConsumerState<TournamentDetailScreen> {
  bool _isJoining = false;
  bool _hasJoined = false;
  bool _showRoomDetails = false;
  late ConfettiController _confettiController;
  bool _confettiTriggered = false;

  /// Mock: simulate that the current user finished top 3
  /// In production, this would come from the API
  int? _mockUserPlacement;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    // Simulate random placement for completed tournaments
    final rng = Random();
    _mockUserPlacement = rng.nextInt(5) + 1; // 1-5
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _joinTournament(TournamentModel tournament) async {
    final walletState = ref.read(walletProvider);
    if (walletState.balance < tournament.entryFee) {
      _showInsufficientFundsDialog();
      return;
    }

    final confirm = await _showConfirmDialog(tournament);
    if (confirm != true) return;

    setState(() => _isJoining = true);
    try {
      await ref
          .read(tournamentRepositoryProvider)
          .joinTournament(tournament.id);
      setState(() {
        _isJoining = false;
        _hasJoined = true;
      });
      if (mounted) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎮 Successfully joined! Good luck!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isJoining = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<bool?> _showConfirmDialog(TournamentModel tournament) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Registration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tournament: ${tournament.title}'),
            const SizedBox(height: 8),
            Text('Entry Fee: ₹${tournament.entryFee.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            const Text('This amount will be deducted from your wallet.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Confirm & Pay',
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
  }

  void _showInsufficientFundsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Insufficient Balance'),
        content: const Text(
            'Your wallet balance is too low. Please add money to join this tournament.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Add Money',
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/wallet/add');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final detailAsync = ref.watch(tournamentDetailProvider(widget.tournamentId));

    return Scaffold(
      appBar: AppBar(
        title: Text('MATCH LOBBY', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
        MeshBackground(
        child: detailAsync.when(

        loading: () => Padding(
          padding: const EdgeInsets.all(16),
          child: LoadingShimmer.list(count: 4, itemHeight: 100),
        ),
        error: (e, _) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(tournamentDetailProvider(widget.tournamentId)),
        ),
        data: (tournament) {
          // Trigger confetti for completed tournaments where user placed top 3
          if (tournament.status == TournamentStatus.completed &&
              _mockUserPlacement != null &&
              _mockUserPlacement! <= 3 &&
              !_confettiTriggered) {
            _confettiTriggered = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _confettiController.play();
              HapticFeedback.heavyImpact();
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Title & Status
              Row(
                children: [
                  Expanded(
                    child: Text(tournament.title.toUpperCase(),
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(tournament.status),
                ],
              ),
              const SizedBox(height: 12),
              AppCard(
                borderRadius: 15,
                child: Text(tournament.description, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              ),
              const SizedBox(height: 24),


              // Info Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _infoCard(Icons.currency_rupee, 'ENTRY FEE', '₹${tournament.entryFee.toStringAsFixed(0)}', AppColors.warning),
                  _infoCard(Icons.emoji_events, 'PRIZE POOL', '₹${tournament.prizePool.toStringAsFixed(0)}', AppColors.secondary),
                  _infoCard(Icons.schedule, 'START TIME', DateFormat('dd MMM, HH:mm').format(tournament.startTime), AppColors.primary),
                  _infoCard(Icons.people, 'SLOTS', '${tournament.joinedCount}/${tournament.maxSlots}', AppColors.secondary),
                  _infoCard(Icons.map, 'MAP', tournament.map, AppColors.secondary),
                  _infoCard(Icons.games, 'MODE', tournament.mode, AppColors.secondary),
                ],
              ),

              const SizedBox(height: 20),

              // Prize Distribution
              if (tournament.prizeDistribution.isNotEmpty) ...[
                Text('Prize Distribution', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isDark ? AppColors.cardGradient : null,
                    color: isDark ? null : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
                  ),
                  child: Column(
                    children: tournament.prizeDistribution.asMap().entries.map((e) {
                      final isFirst = e.key == 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              isFirst ? Icons.emoji_events : Icons.circle,
                              size: isFirst ? 24 : 8,
                              color: isFirst ? AppColors.accent : theme.textTheme.bodySmall?.color,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              e.value,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: isFirst ? FontWeight.w600 : FontWeight.w400,
                                color: isFirst ? AppColors.accent : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Slots Progress
              Text('Slots Filled', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: tournament.joinedCount / tournament.maxSlots,
                  backgroundColor: isDark ? Colors.white.withAlpha(20) : Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(
                    tournament.isFull ? AppColors.error : AppColors.primary,
                  ),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${tournament.availableSlots} slots remaining',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 24),

              // Room Details (only visible after joining + room is set)
              if (_hasJoined && tournament.hasRoomDetails) ...[
                _buildRoomDetails(tournament),
                const SizedBox(height: 24),
              ],

              // Placement banner for completed tournaments
              if (tournament.status == TournamentStatus.completed &&
                  _mockUserPlacement != null &&
                  _mockUserPlacement! <= 3) ...[
                AppCard(
                  borderRadius: 20,
                  useGradient: true,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        _mockUserPlacement == 1
                            ? '🥇'
                            : _mockUserPlacement == 2
                                ? '🥈'
                                : '🥉',
                        style: const TextStyle(fontSize: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _mockUserPlacement == 1
                                  ? 'CHICKEN DINNER!'
                                  : 'TOP ${_mockUserPlacement}!',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Congratulations on your placement!',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Action Button
              if (tournament.isUpcoming && !tournament.isFull && !_hasJoined)
                AppButton(
                  text: 'REGISTER NOW — ₹${tournament.entryFee.toStringAsFixed(0)}',
                  useGradient: true,
                  height: 56,
                  isLoading: _isJoining,
                  onPressed: () => _joinTournament(tournament),
                )
              else if (_hasJoined)
                AppButton(
                  text: _showRoomDetails ? 'HIDE ROOM DETAILS' : 'VIEW ROOM DETAILS',
                  isOutlined: true,
                  height: 56,
                  onPressed: tournament.hasRoomDetails
                      ? () => setState(() => _showRoomDetails = !_showRoomDetails)
                      : null,
                )
              else if (tournament.isFull)
                const AppButton(text: 'TOURNAMENT FULL', onPressed: null, height: 56)
              else if (tournament.isLive)
                const AppButton(text: 'MATCH LIVE', onPressed: null, height: 56),

              const SizedBox(height: 48),

            ],
          ),
        ),
      ),
    );
    },
      ),
    ),
    // Confetti overlay
    Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        numberOfParticles: 30,
        maxBlastForce: 20,
        minBlastForce: 8,
        emissionFrequency: 0.05,
        gravity: 0.15,
        colors: const [
          AppColors.primary,
          AppColors.secondary,
          AppColors.warning,
          AppColors.success,
          AppColors.accent,
          Colors.white,
        ],
      ),
    ),
    ],
    ),
    );
  }


  Widget _infoCard(IconData icon, String label, String value, Color color) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 12,
      showBlur: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textHint, fontSize: 9)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }


  Widget _buildStatusBadge(TournamentStatus status) {
    Color color;
    String label;
    switch (status) {
      case TournamentStatus.upcoming:
        color = AppColors.info;
        label = 'UPCOMING';
        break;
      case TournamentStatus.live:
        color = AppColors.success;
        label = 'LIVE';
        break;
      case TournamentStatus.completed:
        color = AppColors.darkTextHint;
        label = 'COMPLETED';
        break;
      case TournamentStatus.cancelled:
        color = AppColors.error;
        label = 'CANCELLED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildRoomDetails(TournamentModel tournament) {
    final theme = Theme.of(context);

    if (!_showRoomDetails) return const SizedBox.shrink();

    return AppCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.vpn_key, color: AppColors.success, size: 20),
              ),
              const SizedBox(width: 12),
              Text('ROOM ACCESS GRANTED',
                  style: theme.textTheme.titleMedium?.copyWith(color: AppColors.success, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
            ],
          ),
          const SizedBox(height: 20),
          _roomField('ROOM ID', tournament.roomId ?? ''),
          const SizedBox(height: 12),
          _roomField('PASSWORD', tournament.roomPassword ?? ''),

        ],
      ),
    );

  }

  Widget _roomField(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: Theme.of(context).textTheme.bodyMedium),
        Expanded(
          child: Text(value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                  )),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label copied!')),
            );
          },
        ),
      ],
    );
  }
}
