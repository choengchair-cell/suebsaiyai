import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suebsaiyai/core/theme/app_colors.dart';
import 'package:suebsaiyai/core/utils/date_formatter.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';

class StoryCard extends StatefulWidget {
  const StoryCard({super.key, required this.story, this.featured = false});
  final StoryEntity story;
  final bool featured;

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/stories/${widget.story.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.brownWarm,
            border: Border.all(
              color: _hovered
                  ? AppColors.gold.withOpacity(0.35)
                  : Colors.transparent,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image or placeholder
              if (widget.story.coverImageUrl != null)
                AnimatedScale(
                  scale: _hovered ? 1.06 : 1.0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOut,
                  child: Image.network(
                    widget.story.coverImageUrl!,
                    fit: BoxFit.cover,
                    color: _hovered
                        ? Colors.black.withOpacity(0.15)
                        : Colors.black.withOpacity(0.35),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (_, __, ___) => _Placeholder(),
                  ),
                )
              else
                _Placeholder(),

              // Bottom gradient overlay
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _hovered
                          ? [Colors.transparent, const Color(0xFA0D0800)]
                          : [Colors.transparent, const Color(0xF50D0800)],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tag
                      if (widget.story.tags.isNotEmpty)
                        Text(
                          widget.story.tags.first.toUpperCase(),
                          style: GoogleFonts.sarabun(
                            fontSize: 9,
                            letterSpacing: 2.5,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 4),
                      // Title
                      Text(
                        widget.story.title,
                        style: GoogleFonts.notoSerifThai(
                          fontSize: widget.featured ? 20 : 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.cream,
                          height: 1.4,
                        ),
                        maxLines: widget.featured ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Meta
                      Text(
                        '${widget.story.authorName ?? ''} · ${DateFormatter.timeAgo(widget.story.createdAt)}',
                        style: GoogleFonts.sarabun(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Hover arrow
              Positioned(
                top: 12, right: 12,
                child: AnimatedOpacity(
                  opacity: _hovered ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                      border: Border.all(
                          color: AppColors.gold.withOpacity(0.4)),
                    ),
                    child: const Icon(Icons.arrow_forward,
                        color: AppColors.goldLight, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brownWarm,
      child: const Center(
        child: Icon(Icons.auto_stories_outlined,
            size: 48, color: AppColors.glassBorder),
      ),
    );
  }
}
