import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';
import 'package:suebsaiyai/domain/enums/user_role.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isWide = MediaQuery.of(context).size.width >= 900;

    if (isWide) {
      return _WideShell(user: user, child: child);
    }
    return _NarrowShell(user: user, child: child);
  }
}

class _WideShell extends ConsumerWidget {
  const _WideShell({required this.user, required this.child});
  final dynamic user;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          _SideNav(user: user),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NarrowShell extends ConsumerWidget {
  const _NarrowShell({required this.user, required this.child});
  final dynamic user;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNav(user: user),
    );
  }
}

class _SideNav extends ConsumerWidget {
  const _SideNav({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;

    return NavigationRail(
      extended: MediaQuery.of(context).size.width >= 1200,
      backgroundColor: AppColors.surface,
      selectedIndex: _selectedIndex(location),
      onDestinationSelected: (i) => _navigate(context, i, user),
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            const FlutterLogo(size: 32),
            const SizedBox(height: 4),
            Text('สืบสายใย', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
      destinations: _buildDestinations(user),
    );
  }

  int _selectedIndex(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/dashboard')) return 3;
    if (location.startsWith('/review')) return 4;
    if (location.startsWith('/admin')) return 5;
    return 0;
  }

  List<NavigationRailDestination> _buildDestinations(dynamic user) => [
        const NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('หน้าหลัก')),
        const NavigationRailDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: Text('สำรวจ')),
        const NavigationRailDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: Text('ค้นหา')),
        if (user != null) ...[
          const NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('แดชบอร์ด')),
          if (user.role.canReview)
            const NavigationRailDestination(icon: Icon(Icons.rate_review_outlined), selectedIcon: Icon(Icons.rate_review), label: Text('ตรวจสอบ')),
          if (user.role == UserRole.admin)
            const NavigationRailDestination(icon: Icon(Icons.admin_panel_settings_outlined), selectedIcon: Icon(Icons.admin_panel_settings), label: Text('จัดการ')),
        ],
      ];

  void _navigate(BuildContext context, int index, dynamic user) {
    final routes = [
      RouteConstants.home,
      RouteConstants.explore,
      RouteConstants.search,
      if (user != null) ...[
        RouteConstants.dashboard,
        if (user.role.canReview) RouteConstants.reviewQueue,
        if (user.role == UserRole.admin) RouteConstants.adminPanel,
      ],
    ];
    if (index < routes.length) context.go(routes[index]);
  }
}

class _BottomNav extends ConsumerWidget {
  const _BottomNav({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _selectedIndex(location);

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) => _navigate(context, i, user),
      destinations: [
        const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'หน้าหลัก'),
        const NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'สำรวจ'),
        const NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'ค้นหา'),
        if (user != null)
          const NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'ของฉัน'),
      ],
    );
  }

  int _selectedIndex(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/dashboard')) return 3;
    return 0;
  }

  void _navigate(BuildContext context, int index, dynamic user) {
    final routes = [RouteConstants.home, RouteConstants.explore, RouteConstants.search, if (user != null) RouteConstants.dashboard];
    if (index < routes.length) context.go(routes[index]);
  }
}
