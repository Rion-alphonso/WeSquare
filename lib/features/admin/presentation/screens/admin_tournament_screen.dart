import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../tournament/domain/tournament_provider.dart';

import '../../../../core/models/tournament_model.dart';
import '../../../../shared/widgets/app_button.dart';
import 'package:intl/intl.dart';



class AdminTournamentScreen extends ConsumerWidget {
  const AdminTournamentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tourState = ref.watch(tournamentListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('TOURNAMENT MANAGEMENT', style: theme.textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () => _showCreateTournamentSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: MeshBackground(
        child: tourState.isLoading

          ? Padding(
              padding: const EdgeInsets.all(16),
              child: LoadingShimmer.list(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tourState.tournaments.length,
              itemBuilder: (ctx, i) {
                final t = tourState.tournaments[i];
                return _AdminTournamentTile(
                  tournament: t,
                  isDark: isDark,
                  onSetRoom: () => _showSetRoomDialog(context, t),
                  onEdit: () {},
                );
              },
    ),
        ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTournamentSheet(context),
        backgroundColor: AppColors.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('CREATE MATCH', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white)),
      ),
    );
  }


  void _showCreateTournamentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _CreateTournamentSheet(),
    );
  }

  void _showSetRoomDialog(BuildContext context, TournamentModel tournament) {
    final roomIdCtrl = TextEditingController();
    final roomPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Set Room for ${tournament.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: roomIdCtrl,
              decoration: const InputDecoration(
                labelText: 'Room ID',
                prefixIcon: Icon(Icons.meeting_room),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roomPassCtrl,
              decoration: const InputDecoration(
                labelText: 'Room Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Save',
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Room ID set successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminTournamentTile extends StatelessWidget {
  final TournamentModel tournament;
  final bool isDark;
  final VoidCallback onSetRoom;
  final VoidCallback onEdit;

  const _AdminTournamentTile({
    required this.tournament,
    required this.isDark,
    required this.onSetRoom,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  tournament.title.toUpperCase(),
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _statusChip(tournament.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info('FEE', '₹${tournament.entryFee.toStringAsFixed(0)}'),
              _info('PRIZE', '₹${tournament.prizePool.toStringAsFixed(0)}'),
              _info('SLOTS', '${tournament.joinedCount}/${tournament.maxSlots}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(tournament.startTime),
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'SET ROOM ID',
                  height: 36,
                  isOutlined: true,
                  onPressed: onSetRoom,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: 'EDIT DETAILS',
                  height: 36,
                  isOutlined: true,
                  onPressed: onEdit,
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

  Widget _info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
      ],
    );
  }


  Widget _statusChip(TournamentStatus status) {
    final colors = {
      TournamentStatus.upcoming: AppColors.secondary,
      TournamentStatus.live: AppColors.success,
      TournamentStatus.completed: AppColors.error,
      TournamentStatus.cancelled: Colors.grey,
    };
    final color = colors[status]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

}

class _CreateTournamentSheet extends StatefulWidget {
  const _CreateTournamentSheet();

  @override
  State<_CreateTournamentSheet> createState() => _CreateTournamentSheetState();
}

class _CreateTournamentSheetState extends State<_CreateTournamentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _feeCtrl = TextEditingController();
  final _prizeCtrl = TextEditingController();
  final _slotsCtrl = TextEditingController(text: '100');
  final _killMultCtrl = TextEditingController(text: '1.0');
  String _selectedMap = 'Erangel';
  String _selectedMode = 'Classic';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _feeCtrl.dispose();
    _prizeCtrl.dispose();
    _slotsCtrl.dispose();
    _killMultCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Create Tournament', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Tournament Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _feeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Entry Fee (₹)',
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _prizeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Prize Pool (₹)',
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMap,
                      decoration: const InputDecoration(labelText: 'Map'),
                      items: ['Erangel', 'Miramar', 'Sanhok', 'Livik', 'Vikendi']
                          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedMap = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMode,
                      decoration: const InputDecoration(labelText: 'Mode'),
                      items: ['Classic', 'TDM', 'Arena', 'Payload']
                          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedMode = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _slotsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Max Slots'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _killMultCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Kill Multiplier'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Create Tournament',
                useGradient: true,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tournament created successfully! 🎮'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
