import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/tournament_model.dart';

/// Filter bar for tournament list
class TournamentFilterBar extends StatelessWidget {
  final TournamentStatus? selectedStatus;
  final double? selectedMaxFee;
  final ValueChanged<TournamentStatus?> onStatusChanged;
  final ValueChanged<double?> onMaxFeeChanged;
  final VoidCallback onClearFilters;

  const TournamentFilterBar({
    super.key,
    this.selectedStatus,
    this.selectedMaxFee,
    required this.onStatusChanged,
    required this.onMaxFeeChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Status filters
          _FilterChip(
            icon: Icons.grid_view_rounded,
            label: 'All',
            isSelected: selectedStatus == null,
            onTap: () => onStatusChanged(null),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.calendar_today_rounded,
            label: 'Upcoming',
            isSelected: selectedStatus == TournamentStatus.upcoming,
            onTap: () => onStatusChanged(TournamentStatus.upcoming),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.sensors_rounded,
            label: 'Live',
            isSelected: selectedStatus == TournamentStatus.live,
            onTap: () => onStatusChanged(TournamentStatus.live),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.history_toggle_off_rounded,
            label: 'Completed',
            isSelected: selectedStatus == TournamentStatus.completed,
            onTap: () => onStatusChanged(TournamentStatus.completed),
          ),
          const SizedBox(width: 16),

          // Entry fee filter
          _FilterChip(
            icon: Icons.payments_rounded,
            label: '≤₹50',
            isSelected: selectedMaxFee == 50,
            onTap: () =>
                onMaxFeeChanged(selectedMaxFee == 50 ? null : 50),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.payments_rounded,
            label: '≤₹100',
            isSelected: selectedMaxFee == 100,
            onTap: () =>
                onMaxFeeChanged(selectedMaxFee == 100 ? null : 100),
          ),

          const SizedBox(width: 8),

          // Clear
          if (selectedStatus != null || selectedMaxFee != null)
            GestureDetector(
              onTap: onClearFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear, size: 14, color: AppColors.error),
                    SizedBox(width: 4),
                    Text('Clear',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.glassBg,
          borderRadius: BorderRadius.circular(20), // Pill shape
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.glassBorder.withAlpha(20),
          ),
          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withAlpha(80), blurRadius: 8)] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

