import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/mesh_background.dart';
import '../../core/constants/app_colors.dart';

import '../../core/utils/responsive.dart';

/// Adaptive scaffold - bottom nav for mobile, sidebar for tablet/desktop
class AdaptiveScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdaptiveScaffold({
    super.key,
    required this.navigationShell,
  });

  static const _userNavItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.leaderboard_rounded, label: 'Leaderboard'),
    _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = !Responsive.isMobile(context);
    final currentIndex = navigationShell.currentIndex;

    if (isWide) {
      return Scaffold(
        body: MeshBackground(
          child: Row(
            children: [
              // Sidebar for tablet/desktop
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: _onDestinationSelected,
                extended: Responsive.isDesktop(context),
                backgroundColor: Colors.transparent,
                indicatorColor: AppColors.primary.withAlpha(50),
                selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 28),
                unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
                selectedLabelTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                unselectedLabelTextStyle: const TextStyle(color: AppColors.textSecondary),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [BoxShadow(color: AppColors.primaryGlow.withAlpha(100), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.sports_esports, color: Colors.white, size: 24),
                  ),
                ),
                destinations: _userNavItems
                    .map((item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          label: Text(item.label),
                        ))
                    .toList(),
              ),
              const VerticalDivider(width: 1, thickness: 1, color: AppColors.glassBorder),
              // Main content
              Expanded(child: navigationShell),
            ],
          ),
        ),
      );
    }


    // Mobile bottom navigation
    return Scaffold(
      body: MeshBackground(child: navigationShell),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: _onDestinationSelected,
          backgroundColor: AppColors.darkBg, // Solid color
          elevation: 10,

          indicatorColor: AppColors.primary.withAlpha(50),
          destinations: _userNavItems
              .map((item) => NavigationDestination(
                    icon: Icon(item.icon, color: AppColors.textSecondary),
                    selectedIcon: Icon(item.icon, color: AppColors.primary),
                    label: item.label,
                  ))
              .toList(),
        ),
      ),
    );

  }
}

/// Admin scaffold with sidebar navigation
class AdminScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdminScaffold({
    super.key,
    required this.navigationShell,
  });

  static const _adminNavItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.emoji_events_rounded, label: 'Tournaments'),
    _NavItem(icon: Icons.screenshot_rounded, label: 'Screenshots'),
    _NavItem(icon: Icons.account_balance_wallet_rounded, label: 'Withdrawals'),
    _NavItem(icon: Icons.verified_user_rounded, label: 'KYC'),
  ];

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = !Responsive.isMobile(context);
    final currentIndex = navigationShell.currentIndex;

    if (isWide) {
      return Scaffold(
        body: MeshBackground(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: _onDestinationSelected,
                extended: Responsive.isDesktop(context),
                backgroundColor: Colors.transparent,
                indicatorColor: AppColors.primary.withAlpha(50),
                selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 28),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [BoxShadow(color: AppColors.primaryGlow.withAlpha(100), blurRadius: 10)],
                        ),
                        child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 24),
                      ),
                      if (Responsive.isDesktop(context)) ...[
                        const SizedBox(height: 12),
                        Text('ADMIN PANEL',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1)),
                      ],
                    ],
                  ),
                ),
                destinations: _adminNavItems
                    .map((item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          label: Text(item.label),
                        ))
                    .toList(),
              ),
              const VerticalDivider(width: 1, thickness: 1, color: AppColors.glassBorder),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      );
    }


    return Scaffold(
      body: MeshBackground(child: navigationShell),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: _onDestinationSelected,
          backgroundColor: Colors.black.withAlpha(180),
          elevation: 0,
          indicatorColor: AppColors.primary.withAlpha(50),
          destinations: _adminNavItems
              .map((item) => NavigationDestination(
                    icon: Icon(item.icon, color: AppColors.textSecondary),
                    selectedIcon: Icon(item.icon, color: AppColors.primary),
                    label: item.label,
                  ))
              .toList(),
        ),
      ),
    );

  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
