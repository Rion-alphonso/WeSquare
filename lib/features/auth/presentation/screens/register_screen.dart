import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/auth_provider.dart';
import '../widgets/auth_text_field.dart';

import '../../../../shared/widgets/mesh_background.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';


class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _referralCtrl.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).register(
          username: _usernameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          phone: _phoneCtrl.text.trim().isNotEmpty
              ? _phoneCtrl.text.trim()
              : null,
          referralCode: _referralCtrl.text.trim().isNotEmpty
              ? _referralCtrl.text.trim()
              : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated) {
        context.go('/home');
      }
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => context.pop(),
        ),
        title: Text('CREATE ACCOUNT', style: theme.textTheme.headlineSmall),
      ),
      body: MeshBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'JOIN THE BATTLE! 🎮',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'START YOUR COMPETITIVE JOURNEY',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      AppCard(
                        padding: const EdgeInsets.all(20),
                        borderRadius: 20,
                        child: Column(
                          children: [
                            AuthTextField(
                              controller: _usernameCtrl,
                              labelText: 'Username',
                              hintText: 'Choose a gaming username',
                              prefixIcon: Icons.person_outline,
                              validator: Validators.username,
                              maxLength: 20,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _emailCtrl,
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _phoneCtrl,
                              labelText: 'Phone (Optional)',
                              hintText: '10-digit mobile number',
                              prefixIcon: Icons.phone_android,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _passwordCtrl,
                              labelText: 'Password',
                              hintText: 'Min 8 chars with uppercase & number',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              validator: Validators.password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.darkTextHint,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _confirmPasswordCtrl,
                              labelText: 'Confirm Password',
                              hintText: 'Re-enter your password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscureConfirm,
                              validator: (value) {
                                if (value != _passwordCtrl.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.darkTextHint,
                                ),
                                onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                              ),
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              controller: _referralCtrl,
                              labelText: 'Referral Code (Optional)',
                              hintText: 'Enter referral code',
                              prefixIcon: Icons.card_giftcard,
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              text: 'CREATE ACCOUNT',
                              useGradient: true,
                              height: 52,
                              isLoading: authState.isLoading,
                              onPressed: _onRegister,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account? ',
                                    style: theme.textTheme.bodyMedium),
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Text(
                                    'Login',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
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
