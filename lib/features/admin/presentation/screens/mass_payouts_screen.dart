import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/mesh_background.dart';

/// Mock completed tournament with pending payouts
class _PendingPayout {
  final String id;
  final String tournamentName;
  final int playerCount;
  final double totalPrize;
  final List<_WinnerPayout> winners;
  bool isSettled;

  _PendingPayout({
    required this.id,
    required this.tournamentName,
    required this.playerCount,
    required this.totalPrize,
    required this.winners,
    this.isSettled = false,
  });
}

class _WinnerPayout {
  final String playerName;
  final int placement;
  final double amount;

  const _WinnerPayout({
    required this.playerName,
    required this.placement,
    required this.amount,
  });
}

class MassPayoutsScreen extends StatefulWidget {
  const MassPayoutsScreen({super.key});

  @override
  State<MassPayoutsScreen> createState() => _MassPayoutsScreenState();
}

class _MassPayoutsScreenState extends State<MassPayoutsScreen> {
  late List<_PendingPayout> _payouts;
  bool _isProcessing = false;
  int _settledCount = 0;

  @override
  void initState() {
    super.initState();
    _payouts = _generateMockPayouts();
  }

  List<_PendingPayout> get _pendingPayouts =>
      _payouts.where((p) => !p.isSettled).toList();

  double get _totalPendingAmount =>
      _pendingPayouts.fold(0.0, (sum, p) => sum + p.totalPrize);

  void _settleSingle(_PendingPayout payout) async {
    HapticFeedback.lightImpact();
    setState(() => payout.isSettled = true);
    setState(() => _settledCount++);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${payout.tournamentName} — ₹${payout.totalPrize.toStringAsFixed(0)} settled!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _settleAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Mass Payout'),
        content: Text(
            'This will process ₹${_totalPendingAmount.toStringAsFixed(0)} across ${_pendingPayouts.length} tournaments.\n\nCredits will be added to winner wallets.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Settle All',
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);

    // Simulate processing delay
    for (final payout in List.from(_pendingPayouts)) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        HapticFeedback.lightImpact();
        setState(() {
          payout.isSettled = true;
          _settledCount++;
        });
      }
    }

    if (mounted) {
      setState(() => _isProcessing = false);
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 All payouts settled successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = _pendingPayouts;

    return Scaffold(
      appBar: AppBar(
        title: Text('MASS PAYOUTS', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
      ),
      body: MeshBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
          children: [
            // ─── Summary Card ───────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppCard(
                borderRadius: 20,
                useGradient: pending.isNotEmpty,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL PENDING',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white70,
                            letterSpacing: 2.0,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${_totalPendingAmount.toStringAsFixed(0)}',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${pending.length} tournaments • $_settledCount settled',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (pending.isNotEmpty)
                      AppButton(
                        text: _isProcessing ? 'PROCESSING...' : 'SETTLE ALL',
                        width: 120,
                        height: 44,
                        isLoading: _isProcessing,
                        onPressed: _isProcessing ? null : _settleAll,
                      ),
                  ],
                ),
              ),
            ),

            // ─── Payout List ────────────────────
            Expanded(
              child: pending.isEmpty && _settledCount > 0
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text('All Settled!',
                              style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w900)),
                          Text('$_settledCount tournaments processed.',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textHint)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _payouts.length,
                      itemBuilder: (context, index) {
                        final payout = _payouts[index];
                        return _PayoutCard(
                          payout: payout,
                          onSettle: payout.isSettled
                              ? null
                              : () => _settleSingle(payout),
                        );
                      },
                    ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }

  static List<_PendingPayout> _generateMockPayouts() {
    final rng = Random();
    final tournaments = [
      ('Pro League #12', 100, 5000.0),
      ('Squad Showdown #8', 200, 10000.0),
      ('Solo Warrior #15', 100, 3000.0),
      ('Duo Domination #5', 150, 7500.0),
      ('Weekend Classic #42', 100, 2500.0),
      ('Elite Championship', 200, 15000.0),
    ];

    final players = [
      'SniperKing', 'ClutchGod', 'RushB_Pro', 'ShadowFox',
      'IronSight', 'BlazeRunner', 'NightCrawler', 'ViperStrike',
    ];

    return List.generate(tournaments.length, (i) {
      final t = tournaments[i];
      return _PendingPayout(
        id: 'pay_$i',
        tournamentName: t.$1,
        playerCount: t.$2,
        totalPrize: t.$3,
        winners: List.generate(3, (j) {
          return _WinnerPayout(
            playerName: players[rng.nextInt(players.length)],
            placement: j + 1,
            amount: t.$3 * (j == 0 ? 0.4 : j == 1 ? 0.3 : 0.2),
          );
        }),
      );
    });
  }
}

class _PayoutCard extends StatelessWidget {
  final _PendingPayout payout;
  final VoidCallback? onSettle;

  const _PayoutCard({required this.payout, this.onSettle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: payout.isSettled ? 0.5 : 1.0,
        child: AppCard(
          borderRadius: 16,
          showBlur: false,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: payout.isSettled
                          ? AppColors.success.withAlpha(20)
                          : AppColors.warning.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      payout.isSettled ? Icons.check_circle : Icons.payments,
                      color: payout.isSettled
                          ? AppColors.success
                          : AppColors.warning,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(payout.tournamentName,
                            style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800)),
                        Text(
                            '${payout.playerCount} players',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: AppColors.textHint)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${payout.totalPrize.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.secondary)),
                      if (payout.isSettled)
                        Text('SETTLED',
                            style: TextStyle(
                                color: AppColors.success,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Winner breakdown
              ...payout.winners.map((w) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          w.placement == 1
                              ? '🥇'
                              : w.placement == 2
                                  ? '🥈'
                                  : '🥉',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(w.playerName,
                            style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text('₹${w.amount.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )),
              if (!payout.isSettled) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: 'SETTLE PAYOUT',
                    height: 36,
                    isOutlined: true,
                    onPressed: onSettle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
