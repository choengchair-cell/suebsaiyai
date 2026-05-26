import 'package:flutter/material.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';

class StoryStatusChip extends StatelessWidget {
  const StoryStatusChip({super.key, required this.status});
  final StoryStatus status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.displayName, style: const TextStyle(fontSize: 10)),
      backgroundColor: _bgColor,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Color get _bgColor => switch (status) {
        StoryStatus.draft => AppColors.draft.withOpacity(0.2),
        StoryStatus.submitted => AppColors.submitted.withOpacity(0.2),
        StoryStatus.teacherReview || StoryStatus.committeeReview => AppColors.underReview.withOpacity(0.2),
        StoryStatus.approved => AppColors.approved.withOpacity(0.2),
        StoryStatus.published => AppColors.published.withOpacity(0.2),
        StoryStatus.archived => AppColors.archived.withOpacity(0.2),
      };
}
