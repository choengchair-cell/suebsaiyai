import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/application/story/story_list_notifier.dart';
import 'package:suebsaiyai/application/story/story_list_state.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';
import 'package:suebsaiyai/features/story/widgets/story_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesState = ref.watch(publishedStoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('สืบสายใย'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('สืบสายใย', style: theme.textTheme.displaySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('อนุรักษ์ภูมิปัญญาชุมชน', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
                        const SizedBox(height: 24),
                        SearchBar(
                          hintText: 'ค้นหาเรื่องราว...',
                          leading: const Icon(Icons.search),
                          onTap: () => context.go(RouteConstants.search),
                          onChanged: (_) => context.go(RouteConstants.search),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('เรื่องราวล่าสุด', style: theme.textTheme.titleLarge),
                  TextButton(onPressed: () => context.go(RouteConstants.explore), child: const Text('ดูทั้งหมด')),
                ],
              ),
            ),
          ),
          switch (storiesState) {
            StoryListLoading() => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            StoryListError(:final message) => SliverFillRemaining(child: Center(child: Text(message))),
            StoryListLoaded(:final stories) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: stories.length,
                  itemBuilder: (context, index) => StoryCard(story: stories[index]),
                ),
              ),
            _ => const SliverToBoxAdapter(child: SizedBox.shrink()),
          },
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }
}
