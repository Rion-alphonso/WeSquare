import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/mesh_background.dart';
import '../../domain/wallet_provider.dart';



class AddMoneyScreen extends ConsumerStatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  ConsumerState<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends ConsumerState<AddMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  bool _isLoading = false;
  final _quickAmounts = [50, 100, 250, 500, 1000, 2000];

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _onAddMoney() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountCtrl.text);

    setState(() => _isLoading = true);
    try {
      final success = await ref.read(walletProvider.notifier).addMoney(amount);
      setState(() => _isLoading = false);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('₹${amount.toStringAsFixed(0)} added successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to add money. Please try again.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => context.pop(),

        ),
        title: Text('ADD MONEY', style: theme.textTheme.headlineSmall),
      ),
      body: MeshBackground(
        child: SingleChildScrollView(

        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: AppCard(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Amount input
                  Text('ENTER RECHARGE AMOUNT', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondary,
                      shadows: [BoxShadow(color: AppColors.secondaryGlow, blurRadius: 15)],
                    ),
                    validator: (v) => Validators.amount(v, min: 10, max: 50000),
                    decoration: InputDecoration(
                      prefixText: '₹ ',
                      prefixStyle: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900, color: AppColors.secondary),
                      hintText: '0',
                      hintStyle: TextStyle(color: AppColors.secondary.withAlpha(50)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.glassBorder),
                  const SizedBox(height: 20),

                  // Quick amount buttons
                  Text('QUICK SELECT', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _quickAmounts.map((amount) {
                      return GestureDetector(
                        onTap: () =>
                            _amountCtrl.text = amount.toString(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.secondary.withAlpha(40)),
                          ),
                          child: Text(
                            '₹$amount',
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Payment info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withAlpha(20)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.security_outlined,
                            color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Secure payments via Razorpay. Instantly credited to your wallet.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  AppButton(
                    text: 'RECHARGE NOW',
                    useGradient: true,
                    isLoading: _isLoading,
                    onPressed: _onAddMoney,
                  ),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    ),
    );
  }
}

