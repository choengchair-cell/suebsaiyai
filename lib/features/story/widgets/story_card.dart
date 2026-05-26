import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';
import 'package:suebsaiyai/core/utils/date_formatter.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/features/story/widgets/story_status_chip.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key, required this.story});
  final StoryEntity story;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/stories/${story.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (story.coverImageUrl != null)
              Expanded(
                flex: 3,
                child: Image.network(story.coverImageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.primaryContainer, child: const Icon(Icons.image_outlined, size: 48, color: AppColors.primary))),
              )
            else
              Expanded(
                flex: 3,
                child: Container(
                  color: AppColors.primaryContainer,
                  child: const Icon(Icons.auto_stories_outlined, size: 48, color: AppColors.primary),
                ),
              ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StoryStatusChip(status: story.status),
                    const SizedBox(height: 4),
                    Text(story.title, style: theme.textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(DateFormatter.timeAgo(story.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        const Spacer(),
                        if (story.viewCount > 0) ...[
                          const Icon(Icons.visibility_outlined, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${story.viewCount}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
