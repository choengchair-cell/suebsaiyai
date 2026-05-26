import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/story/story_list_notifier.dart';
import 'package:suebsaiyai/application/story/story_list_state.dart';
import 'package:suebsaiyai/features/story/widgets/story_card.dart';

class StoryListPage extends ConsumerWidget {
  const StoryListPage({super.key, this.showMyStories = false});
  final bool showMyStories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(showMyStories ? myStoriesProvider : publishedStoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(showMyStories ? 'เรื่องของฉัน' : 'สำรวจเรื่องราว')),
      body: switch (state) {
        StoryListLoading() => const Center(child: CircularProgressIndicator()),
        StoryListError(:final message) => Center(child: Text(message)),
        StoryListLoaded(:final stories) when stories.isEmpty => const Center(child: Text('ยังไม่มีเรื่องราว')),
        StoryListLoaded(:final stories) => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: stories.length,
            itemBuilder: (context, index) => StoryCard(story: stories[index]),
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
