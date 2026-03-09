import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/tournament_model.dart';
import '../../../../shared/widgets/app_card.dart';



/// Tournament card for display in lists
class TournamentCard extends StatelessWidget {
  final TournamentModel tournament;
  final VoidCallback onTap;

  const TournamentCard({
    super.key,
    required this.tournament,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      showBlur: false, // Huge FPS boost for lists
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "WESQUARE" prefix
          Text(
            'WESQUARE',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),

          // Title row + status badge
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.title.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: tournament.status),
            ],
          ),
          const SizedBox(height: 16),


          // Info Grid (Map, Mode, Fee, Prize)
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _infoTile(Icons.map_outlined, 'Map', tournament.map),
              _infoTile(Icons.people_outline, 'Mode', tournament.mode),
              _infoTile(Icons.currency_rupee, 'Fee', '₹${tournament.entryFee.toStringAsFixed(0)}'),
              _infoTile(Icons.emoji_events_outlined, 'Prize', '₹${tournament.prizePool.toStringAsFixed(0)}'),
            ],
          ),

          const SizedBox(height: 20),


          // Progress label and bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress', 
                    style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  Text('${tournament.joinedCount} / ${tournament.maxSlots}', 
                    style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white.withAlpha(50), width: 0.5),
                ),

                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (tournament.joinedCount / tournament.maxSlots).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: tournament.status == TournamentStatus.live 
                        ? LinearGradient(colors: [AppColors.primary, AppColors.primary.withAlpha(200)])
                        : LinearGradient(colors: [AppColors.secondary, AppColors.secondary.withAlpha(200)]),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: (tournament.status == TournamentStatus.live ? AppColors.primary : AppColors.secondary).withAlpha(150),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}


/// Status badge
class _StatusBadge extends StatelessWidget {
  final TournamentStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case TournamentStatus.upcoming:
        color = AppColors.secondary;
        label = 'UPCOMING';
        break;
      case TournamentStatus.live:
        color = AppColors.success;
        label = 'LIVE';
        break;
      case TournamentStatus.completed:
        color = AppColors.error;
        label = 'COMPLETED';
        break;
      case TournamentStatus.cancelled:
        color = Colors.grey;
        label = 'CANCELLED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(100), width: 1),
        boxShadow: [
          BoxShadow(color: color.withAlpha(30), blurRadius: 4),
        ],
      ),

      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
