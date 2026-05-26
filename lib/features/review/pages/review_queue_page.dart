import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';
import 'package:suebsaiyai/features/story/widgets/story_status_chip.dart';

final _reviewQueueProvider = StreamProvider.autoDispose<List<StoryEntity>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  final status = user.role.canPublish ? StoryStatus.committeeReview : StoryStatus.teacherReview;
  return ref.watch(storyRepositoryProvider).watchStoriesByStatus(status);
});

class ReviewQueuePage extends ConsumerWidget {
  const ReviewQueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(_reviewQueueProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('คิวตรวจสอบ')),
      body: queueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (stories) => stories.isEmpty
            ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle_outline, size: 64, color: Colors.green), SizedBox(height: 16), Text('ไม่มีเรื่องรอตรวจสอบ')]))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: stories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final story = stories[i];
                  return Card(
                    child: ListTile(
                      title: Text(story.title, style: theme.textTheme.titleSmall),
                      subtitle: Text(story.authorName ?? ''),
                      trailing: StoryStatusChip(status: story.status),
                      onTap: () {},
                    ),
                  );
                },
              ),
      ),
    );
  }
}
