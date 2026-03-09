import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../../../core/constants/app_colors.dart';



class AdminKycScreen extends ConsumerWidget {
  const AdminKycScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('USER VERIFICATION', style: theme.textTheme.headlineSmall),
      ),
      body: MeshBackground(
        child: ListView.builder(

        padding: const EdgeInsets.all(16),
        itemCount: _mockKycRequests.length,
        itemBuilder: (ctx, i) {
          final kyc = _mockKycRequests[i];
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
                        border: Border.all(color: AppColors.info, width: 1.5),
                        boxShadow: [BoxShadow(color: AppColors.info.withAlpha(50), blurRadius: 4)],
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.info.withAlpha(20),
                        child: Text(
                          kyc['user']!.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.info,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(kyc['user']!.toUpperCase(), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                          Text('${kyc['docType']} • ${kyc['date']}',
                              style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    _statusBadge(kyc['status']!),
                  ],
                ),

                const SizedBox(height: 12),

                // Document previews
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.badge_outlined, color: AppColors.info.withAlpha(100), size: 32),
                              const SizedBox(height: 6),
                              Text('FRONT VIEW', style: theme.textTheme.labelSmall?.copyWith(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.contact_page_outlined, color: AppColors.info.withAlpha(100), size: 32),
                              const SizedBox(height: 6),
                              Text('BACK VIEW', style: theme.textTheme.labelSmall?.copyWith(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Actions
                if (kyc['status'] == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'REJECT',
                          isOutlined: true,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('KYC rejected'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          text: 'APPROVE',
                          useGradient: true,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('KYC approved ✅'),
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
        color = AppColors.info;
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

const _mockKycRequests = [
  {'user': 'ProPlayer_Mk47', 'docType': 'Aadhaar Card', 'date': '24 Feb', 'status': 'pending'},
  {'user': 'BattleRoyaleQueen', 'docType': 'PAN Card', 'date': '23 Feb', 'status': 'pending'},
  {'user': 'SniperKing99', 'docType': 'Aadhaar Card', 'date': '22 Feb', 'status': 'approved'},
  {'user': 'RushGamer2024', 'docType': 'Driving License', 'date': '21 Feb', 'status': 'rejected'},
];
