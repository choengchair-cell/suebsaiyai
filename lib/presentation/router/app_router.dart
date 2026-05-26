import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/domain/enums/user_role.dart';
import 'package:suebsaiyai/features/admin/pages/admin_dashboard_page.dart';
import 'package:suebsaiyai/features/auth/pages/login_page.dart';
import 'package:suebsaiyai/features/auth/pages/register_page.dart';
import 'package:suebsaiyai/features/dashboard/pages/dashboard_page.dart';
import 'package:suebsaiyai/features/home/pages/home_page.dart';
import 'package:suebsaiyai/features/review/pages/review_queue_page.dart';
import 'package:suebsaiyai/features/search/pages/search_page.dart';
import 'package:suebsaiyai/features/story/pages/story_create_page.dart';
import 'package:suebsaiyai/features/story/pages/story_detail_page.dart';
import 'package:suebsaiyai/features/story/pages/story_edit_page.dart';
import 'package:suebsaiyai/features/story/pages/story_list_page.dart';
import 'package:suebsaiyai/presentation/shell/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final currentUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: RouteConstants.home,
    redirect: (context, state) {
      final isLoading = authState.runtimeType.toString() == 'AuthStateInitial' ||
          authState.runtimeType.toString() == 'AuthStateLoading';
      if (isLoading) return null;

      final isAuthenticated = currentUser != null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isAdminRoute = state.matchedLocation.startsWith('/admin');
      final isReviewRoute = state.matchedLocation.startsWith('/review') || state.matchedLocation.startsWith('/committee');
      final isProtectedRoute = state.matchedLocation.startsWith('/dashboard') ||
          state.matchedLocation.startsWith('/my-stories') ||
          state.matchedLocation.startsWith('/stories/create') ||
          state.matchedLocation.startsWith('/profile');

      if (!isAuthenticated && (isProtectedRoute || isAdminRoute || isReviewRoute)) {
        return '${RouteConstants.login}?redirect=${Uri.encodeComponent(state.uri.toString())}';
      }

      if (isAuthenticated && isAuthRoute) return RouteConstants.dashboard;

      if (isAdminRoute && currentUser?.role != UserRole.admin) return RouteConstants.dashboard;

      if (isReviewRoute && !(currentUser?.role.canReview ?? false)) return RouteConstants.dashboard;

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: RouteConstants.home, builder: (context, state) => const HomePage()),
          GoRoute(path: RouteConstants.explore, builder: (context, state) => const StoryListPage()),
          GoRoute(
            path: RouteConstants.storyDetail,
            builder: (context, state) => StoryDetailPage(storyId: state.pathParameters['id']!),
          ),
          GoRoute(path: RouteConstants.search, builder: (context, state) => const SearchPage()),
          GoRoute(path: RouteConstants.dashboard, builder: (context, state) => const DashboardPage()),
          GoRoute(path: RouteConstants.myStories, builder: (context, state) => const StoryListPage(showMyStories: true)),
          GoRoute(path: RouteConstants.storyCreate, builder: (context, state) => const StoryCreatePage()),
          GoRoute(
            path: RouteConstants.storyEdit,
            builder: (context, state) => StoryEditPage(storyId: state.pathParameters['id']!),
          ),
          GoRoute(path: RouteConstants.reviewQueue, builder: (context, state) => const ReviewQueuePage()),
          GoRoute(path: RouteConstants.adminPanel, builder: (context, state) => const AdminDashboardPage()),
        ],
      ),
      GoRoute(path: RouteConstants.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: RouteConstants.register, builder: (context, state) => const RegisterPage()),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('ไม่พบหน้าที่ต้องการ', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            FilledButton(onPressed: () => context.go(RouteConstants.home), child: const Text('กลับหน้าหลัก')),
          ],
        ),
      ),
    ),
  );
});
