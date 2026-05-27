import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final dynamic user;

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
                _LoginButton(user: user, ref: ref, context: context),
              ] else
                // สำหรับ Mobile: ถ้าเข้าสู่ระบบแล้วสามารถใช้ PopupMenuProfile ย่อยตรงนี้ได้เลย
                if (user != null)
                  _LoginButton(user: user, ref: ref, context: context)
                else
                  // ปุ่มแฮมเบอร์เกอร์รองรับอนาคต
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
  const _LoginButton(
      {required this.user, required this.ref, required this.context});
  final dynamic user;
  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx, WidgetRef r) {
    if (user != null) {
      // ป้องกันการแครชด้วยการแปลง Type จาก dynamic เป็น String ให้ชัดเจน
      final displayName = user.displayName != null 
          ? (user.displayName as String).split(' ').first 
          : 'ผู้ใช้งาน';

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
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.person_outline,
                color: AppColors.goldLight, size: 16),
            const SizedBox(width: 6),
            Text(displayName,
                style: GoogleFonts.sarabun(
                    fontSize
