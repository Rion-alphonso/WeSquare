import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../core/constants/app_colors.dart';



class AdminScreenshotReviewScreen extends ConsumerWidget {
  const AdminScreenshotReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('SCREENSHOT VERIFICATION', style: theme.textTheme.headlineSmall),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: AppColors.secondary),
            onSelected: (v) {},
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'pending', child: Text('Pending Approval')),
              const PopupMenuItem(value: 'approved', child: Text('Verified')),
              const PopupMenuItem(value: 'rejected', child: Text('Rejected')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: MeshBackground(
        child: ListView.builder(

        padding: const EdgeInsets.all(16),
        itemCount: _mockScreenshots.length,
        itemBuilder: (ctx, i) {
          final ss = _mockScreenshots[i];
          return AppCard(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            borderRadius: 18,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                        boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(50), blurRadius: 4)],
                      ),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withAlpha(20),
                        child: Text(
                          ss['player']!.substring(0, 1),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ss['player']!.toUpperCase(),
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                          Text(ss['tournament']!,
                              style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    _statusBadge(ss['status']!),
                  ],
                ),

                const SizedBox(height: 12),

                // Screenshot placeholder
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image, size: 48, color: AppColors.secondary.withAlpha(100)),
                        const SizedBox(height: 8),
                        Text('TAP TO VIEW SCREENSHOT', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w800, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Score input + Actions
                if (ss['status'] == 'pending') ...[
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('KILLS', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                            const SizedBox(height: 6),
                            TextField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: '00',
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RANK', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                            const SizedBox(height: 6),
                            TextField(
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: '#00',
                                isDense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'REJECT',
                          isOutlined: true,
                          height: 40,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Screenshot rejected'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          text: 'VERIFY',
                          useGradient: true,
                          height: 40,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Screenshot approved & score saved ✅'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                ],
              ],
            ),
          );
        },
      ),
    ),
    );
  }






  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'approved':
        color = AppColors.success;
        break;
      case 'rejected':
        color = AppColors.error;
        break;
      default:
        color = AppColors.secondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

}

const _mockScreenshots = [
  {'player': 'ProPlayer_Mk47', 'tournament': 'WeSquare Classic #42', 'status': 'pending'},
  {'player': 'SniperKing99', 'tournament': 'WeSquare Classic #42', 'status': 'pending'},
  {'player': 'BattleRoyaleQueen', 'tournament': 'WeSquare TDM Championship', 'status': 'approved'},
  {'player': 'RushGamer2024', 'tournament': 'WeSquare Classic #41', 'status': 'rejected'},

];
