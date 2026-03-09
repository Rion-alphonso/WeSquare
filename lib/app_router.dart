import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Auth
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/domain/auth_provider.dart';

// User feature screens
import 'features/tournament/presentation/screens/home_screen.dart';
import 'features/tournament/presentation/screens/tournament_detail_screen.dart';
import 'features/tournament/presentation/screens/squad_board_screen.dart';
import 'features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'features/wallet/presentation/screens/wallet_screen.dart';
import 'features/wallet/presentation/screens/add_money_screen.dart';
import 'features/wallet/presentation/screens/withdraw_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/notifications/presentation/screens/notifications_screen.dart';

// Admin feature screens
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/admin/presentation/screens/admin_tournament_screen.dart';
import 'features/admin/presentation/screens/admin_screenshot_review_screen.dart';
import 'features/admin/presentation/screens/admin_withdrawal_screen.dart';
import 'features/admin/presentation/screens/admin_kyc_screen.dart';
import 'features/admin/presentation/screens/bulk_verification_screen.dart';
import 'features/admin/presentation/screens/mass_payouts_screen.dart';

// Shared
import 'shared/widgets/adaptive_scaffold.dart';

/// Navigation keys

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _userShellKey = GlobalKey<NavigatorState>();
final _adminShellKey = GlobalKey<NavigatorState>();

/// Router provider — reactive to auth state changes without recreating the GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  
  // Create a Listenable that triggers when auth state changes
  final refreshListenable = ValueNotifier<AuthState>(ref.watch(authProvider));
  ref.listen(authProvider, (_, next) => refreshListenable.value = next);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: refreshListenable,
    debugLogDiagnostics: true,

    // Redirect logic based on auth state
    redirect: (context, state) {
      final authState = refreshListenable.value;
      final isAuthenticated = authState.isAuthenticated;
      final isAdmin = authState.isAdmin;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/otp';

      // Not authenticated → redirect to login
      if (!isAuthenticated && !isAuthRoute) return '/login';

      // Authenticated user on auth page → redirect to home
      if (isAuthenticated && isAuthRoute) {
        return isAdmin ? '/admin' : '/home';
      }

      // Prevent regular users from accessing admin routes
      if (!isAdmin && state.matchedLocation.startsWith('/admin')) {
        return '/home';
      }

      return null; // No redirect
    },


    routes: [
      // ─── Auth Routes ──────────────────────────────
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpScreen(phone: phone);
        },
      ),

      // ─── User Shell (Bottom Nav / Sidebar) ────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Home / Tournaments
          StatefulShellBranch(
            navigatorKey: _userShellKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'tournament/:id',
                    name: 'tournament-detail',
                    builder: (context, state) => TournamentDetailScreen(
                      tournamentId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'squads',
                    name: 'squad-board',
                    builder: (context, state) => const SquadBoardScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    name: 'notifications',
                    builder: (context, state) => const NotificationsScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Leaderboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/leaderboard',
                name: 'leaderboard',
                builder: (context, state) => const LeaderboardScreen(),
              ),
            ],
          ),

          // Wallet
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                name: 'wallet',
                builder: (context, state) => const WalletScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    name: 'wallet-add',
                    builder: (context, state) => const AddMoneyScreen(),
                  ),
                  GoRoute(
                    path: 'withdraw',
                    name: 'wallet-withdraw',
                    builder: (context, state) => const WithdrawScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ─── Tournament Detail (top-level for deep links) ──
      GoRoute(
        path: '/tournament/:id',
        name: 'tournament-detail-root',
        builder: (context, state) => TournamentDetailScreen(
          tournamentId: state.pathParameters['id']!,
        ),
      ),

      // ─── Admin Shell ──────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard
          StatefulShellBranch(
            navigatorKey: _adminShellKey,
            routes: [
              GoRoute(
                path: '/admin',
                name: 'admin-dashboard',
                builder: (context, state) => const AdminDashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'bulk-verify',
                    name: 'admin-bulk-verify',
                    builder: (context, state) => const BulkVerificationScreen(),
                  ),
                  GoRoute(
                    path: 'mass-payouts',
                    name: 'admin-mass-payouts',
                    builder: (context, state) => const MassPayoutsScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Tournament Management
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/tournaments',
                name: 'admin-tournaments',
                builder: (context, state) =>
                    const AdminTournamentScreen(),
              ),
            ],
          ),
          // Screenshot Review
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/screenshots',
                name: 'admin-screenshots',
                builder: (context, state) =>
                    const AdminScreenshotReviewScreen(),
              ),
            ],
          ),
          // Withdrawals
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/withdrawals',
                name: 'admin-withdrawals',
                builder: (context, state) =>
                    const AdminWithdrawalScreen(),
              ),
            ],
          ),
          // KYC
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/kyc',
                name: 'admin-kyc',
                builder: (context, state) => const AdminKycScreen(),
              ),
            ],
          ),
        ],
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.matchedLocation),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
