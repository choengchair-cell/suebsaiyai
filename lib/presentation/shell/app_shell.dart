import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';
import 'package:suebsaiyai/domain/entities/user_entity.dart';
import 'package:suebsaiyai/domain/enums/user_role.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.brownDark,
      extendBodyBehindAppBar: true,
      appBar: _GlassNavBar(user: user),
      body: child,
      bottomNavigationBar: MediaQuery.of(context).size.width < 900
          ? _BottomNav(user: user)
          : null,
    );
  }
}

// ─── GLASSMORPHISM NAVBAR ──────────────────────────────────────────────────────
class _GlassNavBar extends ConsumerWidget implements PreferredSizeWidget {
  const _GlassNavBar({required this.user});
  final UserEntity? user;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 24,
            right: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.38),
            border: Border(
              bottom: BorderSide(color: AppColors.gold.withOpacity(0.12)),
            ),
          ),
          child: Row(
            children: [
              // Logo
              GestureDetector(
                onTap: () => context.go(RouteConstants.home),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('สืบสายใย',
                        style: GoogleFonts.notoSerifThai(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldLight)),
                    Text('Suebsaiyai · Non Thai District',
                        style: GoogleFonts.sarabun(
                            fontSize: 10,
                            color: AppColors.textMuted,
                            letterSpacing: 1.2)),
                  ],
                ),
              ),
              const Spacer(),
              // Nav links (wide)
              if (MediaQuery.of(context).size.width >= 900) ...[
                _navLink('เรื่องเล่า', RouteConstants.explore,
                    location.startsWith('/explore'), context),
                const SizedBox(width: 32),
                _navLink('ค้นหา', RouteConstants.search,
                    location.startsWith('/search'), context),
                const SizedBox(width: 32),
                if (user != null) ...[
                  _navLink('แดชบอร์ด', RouteConstants.dashboard,
                      location.startsWith('/dashboard'), context),
                  const SizedBox(width: 32),
                ],
                _LoginButton(user: user),
              ] else
                // สำหรับ Mobile
                if (user != null)
                  _LoginButton(user: user)
                else
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.goldLight),
                    onPressed: () {},
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navLink(
      String label, String route, bool active, BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(route),
      child: Text(
        label,
        style: GoogleFonts.sarabun(
          fontSize: 13,
          color: active ? AppColors.goldLight : AppColors.textLight,
          fontWeight: active ? FontWeight.w500 : FontWeight.w400,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ─── LOGIN BUTTON ──────────────────────────────────────────────────────────────
class _LoginButton extends ConsumerWidget {
  const _LoginButton({required this.user});
  final UserEntity? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user != null) {
      final loggedInUser = user!;
      final String displayName = loggedInUser.displayName.split(' ').first;
      final bool isAdmin = loggedInUser.role == UserRole.admin;

      return PopupMenuButton<String>(
        color: const Color(0xFF100800),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.gold.withOpacity(0.2)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.glassBorder),
            borderRadius: BorderRadius.circular(2),
            color: AppColors.primaryContainer,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline,
                  color: AppColors.goldLight, size: 16),
              const SizedBox(width: 6),
              Text(displayName,
                  style: GoogleFonts.sarabun(
                      fontSize: 13, color: AppColors.goldLight)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.goldLight, size: 14),
            ],
          ),
        ),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'dashboard',
            child: _roleMenuItem(Icons.dashboard_outlined, 'แดชบอร์ด'),
          ),
          if (isAdmin)
            PopupMenuItem(
              value: 'admin',
              child: _roleMenuItem(Icons.admin_panel_settings_outlined, 'จัดการระบบ'),
            ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'logout',
            child: _roleMenuItem(Icons.logout, 'ออกจากระบบ',
                color: AppColors.error),
          ),
        ],
        onSelected: (v) async {
          switch (v) {
            case 'dashboard':
              if (context.mounted) context.go(RouteConstants.dashboard);
              break;
            case 'admin':
              if (context.mounted) context.go(RouteConstants.adminPanel);
              break;
            case 'logout':
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go(RouteConstants.home);
              break;
          }
        },
      );
    }

    return const _RoleLoginButton();
  }

  Widget _roleMenuItem(IconData icon, String label,
          {Color color = AppColors.textLight}) =>
      Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 10),
        Text(label,
            style: GoogleFonts.sarabun(fontSize: 13, color: color)),
      ]);
}

class _RoleLoginButton extends StatefulWidget {
  const _RoleLoginButton();
  @override
  State<_RoleLoginButton> createState() => _RoleLoginButtonState();
}

class _RoleLoginButtonState extends State<_RoleLoginButton> {
  static const _roles = [
    ('🎒', 'Field · นักศึกษา', 'บันทึกภูมิปัญญาภาคสนาม'),
    ('👩‍🏫', 'Teacher · ครู สกร.', 'ตรวจสอบและจัดการข้อมูล'),
    ('⚖️', 'Committee · คณะกรรมการ', 'อนุมัติและรับรองข้อมูล'),
    ('🛡️', 'Admin · ผู้ดูแลระบบ', 'จัดการผู้ใช้และระบบทั้งหมด'),
  ];

  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: const Color(0xFF0A0600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.gold.withOpacity(0.22)),
      ),
      offset: const Offset(0, 48),
      onOpened: () => setState(() => _open = true),
      onCanceled: () => setState(() => _open = false),
      onSelected: (_) {
        setState(() => _open = false);
        context.go(RouteConstants.login);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(2),
          color: AppColors.primaryContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔐', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            Text('เข้าสู่ระบบ',
                style: GoogleFonts.sarabun(
                    fontSize: 13,
                    color: AppColors.goldLight,
                    letterSpacing: 0.4)),
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              child: const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.goldLight, size: 14),
            ),
          ],
        ),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          height: 36,
          child: Text('เลือกประเภทผู้ใช้งาน',
              style: GoogleFonts.sarabun(
                  fontSize: 9,
                  letterSpacing: 3,
                  color: AppColors.textMuted)),
        ),
        ..._roles.asMap().entries.map((e) => PopupMenuItem<int>(
              value: e.key,
              child: Row(children: [
                Text(e.value.$1,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(e.value.$2,
                            style: GoogleFonts.sarabun(
                                fontSize: 13,
                                color: AppColors.cream,
                                fontWeight: FontWeight.w500)),
                        Text(e.value.$3,
                            style: GoogleFonts.sarabun(
                                fontSize: 11,
                                color: AppColors.textMuted)),
                      ]),
                ),
              ]),
            )),
      ],
    );
  }
}

// ─── BOTTOM NAV (mobile) ───────────────────────────────────────────────────────
class _BottomNav extends ConsumerWidget {
  const _BottomNav({required this.user});
  final UserEntity? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;

    final destinations = [
      const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'หน้าหลัก'),
      const NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'สำรวจ'),
      const NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'ค้นหา'),
      if (user != null)
        const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'ของฉัน')
      else
        const NavigationDestination(
            icon: Icon(Icons.login_outlined),
            selectedIcon: Icon(Icons.login),
            label: 'เข้าสู่ระบบ'),
    ];

    int idx = 0;
    if (location.startsWith('/explore')) idx = 1;
    if (location.startsWith('/search')) idx = 2;
    if (location.startsWith('/dashboard')) idx = 3;
    if (location.startsWith('/login')) idx = user != null ? 0 : 3;

    return NavigationBar(
      selectedIndex: idx,
      backgroundColor: AppColors.brownMid,
      indicatorColor: AppColors.primaryContainer,
      onDestinationSelected: (i) {
        final routes = [
          RouteConstants.home,
          RouteConstants.explore,
          RouteConstants.search,
          if (user != null) RouteConstants.dashboard else RouteConstants.login,
        ];
        if (i < routes.length) context.go(routes[i]);
      },
      destinations: destinations,
    );
  }
}
