import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/core/utils/date_formatter.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';
import 'package:suebsaiyai/features/story/widgets/story_status_chip.dart';

final _storyDetailProvider = FutureProvider.autoDispose.family((ref, String id) async {
  final result = await ref.watch(storyRepositoryProvider).getStory(id);
  return result.fold((f) => throw Exception(f.message), (s) => s);
});

class StoryDetailPage extends ConsumerWidget {
  const StoryDetailPage({super.key, required this.storyId});
  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(_storyDetailProvider(storyId));
    final currentUser = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return storyAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (story) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(story.title, maxLines: 2),
              actions: [
                if (currentUser?.uid == story.authorId && story.status == StoryStatus.draft)
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      StoryStatusChip(status: story.status),
                      const SizedBox(width: 8),
                      Text(DateFormatter.toThaiDate(story.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    ],
                  ),
                  if (story.authorName != null) ...[
                    const SizedBox(height: 8),
                    Row(children: [const Icon(Icons.person_outline, size: 16), const SizedBox(width: 4), Text(story.authorName!)]),
                  ],
                  if (story.tags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: story.tags.map((tag) => Chip(label: Text(tag), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)).toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  SelectableText(story.content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
