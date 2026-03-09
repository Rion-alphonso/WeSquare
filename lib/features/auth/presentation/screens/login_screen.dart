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


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();

  // Email controllers
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  // Phone controllers
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onEmailLogin() {
    if (!_emailFormKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  void _onPhoneSendOtp() {
    if (!_phoneFormKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).sendOtp(phone: _phoneCtrl.text.trim());
    context.push('/otp', extra: _phoneCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.isAuthenticated) {
        context.go(next.isAdmin ? '/admin' : '/home');
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
      body: MeshBackground(
        child: SafeArea(
          child: Center(

          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ─── Logo & Title ────────────────
                  const SizedBox(height: 32),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(80),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.sports_esports,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  Text('WESQUARE',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Text('LOGIN TO YOUR ACCOUNT',
                      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                  const SizedBox(height: 32),


                  // ─── Tab Bar ─────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassBg,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: AppColors.primaryGradient,
                        boxShadow: [BoxShadow(color: AppColors.primaryGlow, blurRadius: 10)],
                      ),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.textHint,
                      labelStyle: const TextStyle(
                          fontFamily: 'Exo 2',
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 1.1),
                      tabs: const [
                        Tab(text: 'EMAIL'),
                        Tab(text: 'PHONE'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Tab Views ───────────────────
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    borderRadius: 20,
                    child: SizedBox(
                      height: 340,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildEmailTab(authState),
                          _buildPhoneTab(authState),
                        ],
                      ),
                    ),
                  ),


                  // ─── Register Link ──────────────
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: theme.textTheme.bodyMedium),
                      GestureDetector(
                        onTap: () => context.push('/register'),
                        child: Text(
                          'Register',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }


  Widget _buildEmailTab(AuthState authState) {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: [
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
            controller: _passwordCtrl,
            labelText: 'Password',
            hintText: 'Enter your password',
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
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot Password?',
                  style: TextStyle(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          AppButton(
            text: 'LOGIN',
            useGradient: true,
            width: double.infinity,
            height: 52,
            isLoading: authState.isLoading,
            onPressed: _onEmailLogin,
          ),
          const SizedBox(height: 16),
          // Quick Admin Demo Login
          OutlinedButton.icon(
            onPressed: () {
              _emailCtrl.text = 'admin@wesquare.com';
              _passwordCtrl.text = 'admin123';
              _onEmailLogin();
            },
            icon: const Icon(Icons.admin_panel_settings, color: AppColors.secondary),
            label: const Text('ADMIN LOGIN DEMO'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: BorderSide(color: AppColors.secondary.withAlpha(100)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTab(AuthState authState) {
    return Form(
      key: _phoneFormKey,
      child: Column(
        children: [
          AuthTextField(
            controller: _phoneCtrl,
            labelText: 'Phone Number',
            hintText: 'Enter 10-digit mobile number',
            prefixIcon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            validator: Validators.phone,
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          AppButton(
            text: 'SEND OTP',
            useGradient: true,
            width: double.infinity,
            height: 52,
            isLoading: authState.isLoading,
            onPressed: _onPhoneSendOtp,
          ),

          const SizedBox(height: 16),
          Text(
            'We\'ll send a 6-digit code to your phone',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
