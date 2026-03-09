import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/mesh_background.dart';

/// Mock screenshot submission for bulk review
class _ScreenshotSubmission {
  final String id;
  final String playerName;
  final String tournamentName;
  final int kills;
  final String screenshotUrl;
  bool isApproved;
  bool isRejected;
  bool isReviewed;

  _ScreenshotSubmission({
    required this.id,
    required this.playerName,
    required this.tournamentName,
    required this.kills,
    required this.screenshotUrl,
    this.isApproved = false,
    this.isRejected = false,
    this.isReviewed = false,
  });
}

class BulkVerificationScreen extends StatefulWidget {
  const BulkVerificationScreen({super.key});

  @override
  State<BulkVerificationScreen> createState() => _BulkVerificationScreenState();
}

class _BulkVerificationScreenState extends State<BulkVerificationScreen> {
  late List<_ScreenshotSubmission> _submissions;
  int _approvedCount = 0;
  int _rejectedCount = 0;

  @override
  void initState() {
    super.initState();
    _submissions = _generateMockSubmissions();
  }

  List<_ScreenshotSubmission> get _pendingSubmissions =>
      _submissions.where((s) => !s.isReviewed).toList();

  void _approve(_ScreenshotSubmission sub) {
    HapticFeedback.lightImpact();
    setState(() {
      sub.isApproved = true;
      sub.isReviewed = true;
      _approvedCount++;
    });
  }

  void _reject(_ScreenshotSubmission sub) {
    HapticFeedback.mediumImpact();
    setState(() {
      sub.isRejected = true;
      sub.isReviewed = true;
      _rejectedCount++;
    });
  }

  void _approveAll() {
    HapticFeedback.heavyImpact();
    setState(() {
      for (final sub in _pendingSubmissions) {
        sub.isApproved = true;
        sub.isReviewed = true;
        _approvedCount++;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ All remaining screenshots approved!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = _pendingSubmissions;

    return Scaffold(
      appBar: AppBar(
        title: Text('BULK VERIFY', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
        actions: [
          if (pending.isNotEmpty)
            TextButton.icon(
              onPressed: _approveAll,
              icon: const Icon(Icons.done_all, color: AppColors.success, size: 18),
              label: Text('APPROVE ALL',
                  style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w800)),
            ),
        ],
      ),
      body: MeshBackground(
        child: Column(
          children: [
            // ─── Stats Header ───────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  _counterBadge('PENDING', pending.length, AppColors.warning),
                  const SizedBox(width: 8),
                  _counterBadge('APPROVED', _approvedCount, AppColors.success),
                  const SizedBox(width: 8),
                  _counterBadge('REJECTED', _rejectedCount, AppColors.error),
                ],
              ),
            ),

            // ─── Grid / Queue ───────────────────
            Expanded(
              child: pending.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 64, color: AppColors.success.withAlpha(150)),
                          const SizedBox(height: 16),
                          Text('All clear!',
                              style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppColors.success, fontWeight: FontWeight.w900)),
                          Text('No pending screenshots to review.',
                              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textHint)),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        mainAxisExtent: 350,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: pending.length,
                      itemBuilder: (context, index) {
                        return _ScreenshotCard(
                          submission: pending[index],
                          onApprove: () => _approve(pending[index]),
                          onReject: () => _reject(pending[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterBadge(String label, int count, Color color) {
    return Expanded(
      child: AppCard(
        borderRadius: 12,
        showBlur: false,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Text('$count',
                style: TextStyle(
                    color: color, fontSize: 20, fontWeight: FontWeight.w900)),
            Text(label,
                style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0)),
          ],
        ),
      ),
    );
  }

  static List<_ScreenshotSubmission> _generateMockSubmissions() {
    final rng = Random();
    final players = [
      'SniperKing', 'ClutchGod', 'RushB_Pro', 'ShadowFox',
      'IronSight', 'BlazeRunner', 'NightCrawler', 'ViperStrike',
      'ThunderBolt', 'StormBreaker', 'DarkKnight', 'PhantomX',
    ];
    final tournaments = [
      'Pro League #1', 'Squad Showdown', 'Solo Warrior',
      'Duo Domination', 'Weekend Classic',
    ];

    return List.generate(12, (i) {
      return _ScreenshotSubmission(
        id: 'ss_$i',
        playerName: players[i % players.length],
        tournamentName: tournaments[rng.nextInt(tournaments.length)],
        kills: rng.nextInt(12) + 1,
        screenshotUrl: 'asset_placeholder_$i',
      );
    });
  }
}

class _ScreenshotCard extends StatelessWidget {
  final _ScreenshotSubmission submission;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ScreenshotCard({
    required this.submission,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      borderRadius: 16,
      padding: EdgeInsets.zero,
      showBlur: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mock screenshot placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.glassBg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withAlpha(15),
                    AppColors.secondary.withAlpha(15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined,
                        size: 40, color: AppColors.textHint.withAlpha(100)),
                    const SizedBox(height: 8),
                    Text('${submission.kills} KILLS',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.secondary)),
                  ],
                ),
              ),
            ),
          ),

          // Info + actions
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(submission.playerName,
                    style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 12)),
                Text(submission.tournamentName,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint, fontSize: 9)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onApprove,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.success.withAlpha(40)),
                          ),
                          child: const Center(
                            child: Text('✓',
                                style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: onReject,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withAlpha(20),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: AppColors.error.withAlpha(40)),
                          ),
                          child: const Center(
                            child: Text('✕',
                                style: TextStyle(
                                    color: AppColors.error,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
