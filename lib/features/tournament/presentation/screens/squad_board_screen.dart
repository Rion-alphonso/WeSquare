import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/mesh_background.dart';

/// LFG (Looking For Group) request model
class LfgRequest {
  final String id;
  final String username;
  final String message;
  final String mode;
  final String rank;
  final DateTime postedAt;
  final int spotsNeeded;

  const LfgRequest({
    required this.id,
    required this.username,
    required this.message,
    required this.mode,
    required this.rank,
    required this.postedAt,
    this.spotsNeeded = 1,
  });
}

class SquadBoardScreen extends StatefulWidget {
  const SquadBoardScreen({super.key});

  @override
  State<SquadBoardScreen> createState() => _SquadBoardScreenState();
}

class _SquadBoardScreenState extends State<SquadBoardScreen> {
  final _messageController = TextEditingController();
  String _selectedMode = 'Squad';
  final List<LfgRequest> _requests = _generateMockRequests();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _postRequest() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _requests.insert(
        0,
        LfgRequest(
          id: 'lfg_${DateTime.now().millisecondsSinceEpoch}',
          username: 'ProGamer99',
          message: _messageController.text.trim(),
          mode: _selectedMode,
          rank: 'Diamond',
          postedAt: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('FIND A SQUAD', style: theme.textTheme.headlineSmall),
        backgroundColor: Colors.transparent,
      ),
      body: MeshBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // ─── Post LFG ─────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: AppCard(
                    borderRadius: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'POST LFG REQUEST',
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 2.0,
                            color: AppColors.secondary,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _messageController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'Looking for 2 aggressive players for Squad...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.glassBorder),
                            ),
                            filled: true,
                            fillColor: AppColors.glassBg,
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Mode selector
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.glassBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.glassBorder),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedMode,
                                    isExpanded: true,
                                    dropdownColor: AppColors.darkBgSecondary,
                                    items: ['Squad', 'Duo', 'Solo'].map((m) {
                                      return DropdownMenuItem(
                                        value: m,
                                        child: Text(m,
                                            style: theme.textTheme.bodyMedium),
                                      );
                                    }).toList(),
                                    onChanged: (v) =>
                                        setState(() => _selectedMode = v!),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            AppButton(
                              text: 'POST',
                              width: 100,
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              useGradient: true,
                              onPressed: _postRequest,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── LFG Feed ─────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
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
                      Text('RECENT REQUESTS',
                          style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                      const Spacer(),
                      Text('${_requests.length} active',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: AppColors.textHint)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      return _LfgCard(request: _requests[index]);
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

  static List<LfgRequest> _generateMockRequests() {
    final rng = Random();
    final usernames = [
      'SniperKing',
      'ClutchGod',
      'RushB_Pro',
      'ShadowFox',
      'IronSight',
      'NightCrawler',
      'ViperStrike',
      'BlazeRunner',
    ];
    final messages = [
      'Need 2 aggressive pushers for Squad rank push 🔥',
      'LF1 more for duo grind. Must have mic!',
      'Chill squad games, no toxicity. Come vibe 🎮',
      'Anyone down for scrims? Diamond+ only',
      'Looking for IGL with good comms for tournament',
      'Need sniper support player for upcoming match',
      'Forming a new squad. Serious players only 💪',
      'LF teammates for the Pro League qualifier',
    ];
    final ranks = ['Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond', 'Crown', 'Ace'];
    final modes = ['Squad', 'Duo', 'Squad', 'Squad', 'Duo', 'Squad', 'Squad', 'Squad'];

    return List.generate(8, (i) {
      return LfgRequest(
        id: 'lfg_$i',
        username: usernames[i],
        message: messages[i],
        mode: modes[i],
        rank: ranks[rng.nextInt(ranks.length)],
        postedAt: DateTime.now().subtract(Duration(minutes: rng.nextInt(120) + 5)),
        spotsNeeded: rng.nextInt(3) + 1,
      );
    });
  }
}

class _LfgCard extends StatelessWidget {
  final LfgRequest request;
  const _LfgCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ago = DateTime.now().difference(request.postedAt);
    final timeLabel = ago.inMinutes < 60
        ? '${ago.inMinutes}m ago'
        : '${ago.inHours}h ago';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        borderRadius: 16,
        showBlur: false,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withAlpha(30),
                  child: Text(
                    request.username.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.username,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: [
                          _tag(request.rank, AppColors.accent),
                          const SizedBox(width: 6),
                          _tag(request.mode, AppColors.info),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(timeLabel,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.textHint, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 10),
            Text(request.message, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person_add_alt_1,
                    size: 14, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text(
                  '${request.spotsNeeded} spot${request.spotsNeeded > 1 ? 's' : ''} open',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  child: AppButton(
                    text: 'JOIN',
                    width: 75,
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    useGradient: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Request sent to ${request.username}!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
