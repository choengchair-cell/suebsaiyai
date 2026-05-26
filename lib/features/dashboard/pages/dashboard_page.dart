import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go(RouteConstants.login));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('แดชบอร์ด'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: () => ref.read(authNotifierProvider.notifier).signOut(), tooltip: 'ออกจากระบบ'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(radius: 28, backgroundColor: AppColors.primary, child: Text(user.displayName.substring(0, 1), style: const TextStyle(color: Colors.white, fontSize: 24))),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName, style: theme.textTheme.titleLarge),
                          Text(user.role.displayName, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary)),
                          Text(user.email, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('เมนูหลัก', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _DashboardCard(icon: Icons.auto_stories_outlined, title: 'เรื่องของฉัน', onTap: () => context.go(RouteConstants.myStories)),
                _DashboardCard(icon: Icons.add_circle_outline, title: 'เพิ่มเรื่องใหม่', onTap: () => context.go(RouteConstants.storyCreate)),
                if (user.role.canReview) _DashboardCard(icon: Icons.rate_review_outlined, title: 'ตรวจสอบเรื่อง', onTap: () => context.go(RouteConstants.reviewQueue)),
                if (user.role.canManageUsers) _DashboardCard(icon: Icons.admin_panel_settings_outlined, title: 'จัดการระบบ', onTap: () => context.go(RouteConstants.adminPanel)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}
