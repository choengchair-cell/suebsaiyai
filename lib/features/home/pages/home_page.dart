import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.brownDark,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroSection(isWide: isWide)),
          const SliverToBoxAdapter(child: _StatsSection()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('คลังเรื่องเล่า',
                          style: GoogleFonts.sarabun(
                              fontSize: 10, letterSpacing: 3.5,
                              color: AppColors.gold, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text(
                        '10 ตำบล · เรื่องราวชุมชน\nหนึ่งสายใยแห่งความทรงจำ',
                        style: GoogleFonts.notoSerifThai(
                            fontSize: isWide ? 28 : 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cream,
                            height: 1.3),
                      ),
                    ],
                  ),
                  FilledButton(
                      onPressed: () => context.go(RouteConstants.explore),
                      child: const Text('ดูทั้งหมด')),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 24)),
          switch (storiesState) {
            StoryListLoading() => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
                ),
              ),
            StoryListError(:final message) => SliverToBoxAdapter(
                child: Center(
                    child: Text(message,
                        style: const TextStyle(color: AppColors.textMuted)))),
            StoryListLoaded(:final stories) when stories.isEmpty =>
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(
                      child: Text('ยังไม่มีเรื่องราว',
                          style: TextStyle(color: AppColors.textMuted))),
                ),
              ),
            StoryListLoaded(:final stories) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: isWide ? 380 : 340,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 4 / 3,
                  ),
                  itemCount: stories.length,
                  itemBuilder: (context, i) =>
                      StoryCard(story: stories[i], featured: i == 0),
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

// ─── HERO ──────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isWide});
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isWide ? MediaQuery.of(context).size.height : 520,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background gradient (swap for Image.asset when 1stpage.png is added)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A0F00), Color(0xFF0D0800), Color(0xFF2D1A00)],
              ),
            ),
          ),
          // Gold radial glow
          Positioned(
            left: -100, top: 100,
            child: Container(
              width: 500, height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.gold.withOpacity(0.07), Colors.transparent],
                ),
              ),
            ),
          ),
          // Bottom fade to brownDark
          Positioned(
            bottom: 0, left: 0, right: 0, height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.brownDark],
                ),
              ),
            ),
          ),
          // Hero content
          Positioned(
            bottom: isWide ? 96 : 48,
            left: isWide ? 48 : 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Container(width: 36, height: 1, color: AppColors.gold),
                  const SizedBox(width: 12),
                  Text('โนนไทย · นครราชสีมา · 10 ตำบล',
                      style: GoogleFonts.sarabun(
                          fontSize: 10, letterSpacing: 3.5,
                          color: AppColors.gold, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 12),
                  Container(width: 36, height: 1, color: AppColors.gold),
                ]),
                const SizedBox(height: 28),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.notoSerifThai(
                        fontSize: isWide ? 52 : 30,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cream,
                        height: 1.25),
                    children: [
                      const TextSpan(text: 'ภูมิปัญญาไม่ได้หายไป\nเพียงกำลัง'),
                      TextSpan(
                        text: 'รอการสืบต่อ',
                        style: TextStyle(
                          color: AppColors.goldLight,
                          shadows: [
                            Shadow(
                                color: AppColors.goldLight.withOpacity(0.55),
                                blurRadius: 40)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Text(
                    'แพลตฟอร์มบันทึกและเชื่อมต่อภูมิปัญญาผู้สูงวัย\nจาก 10 ตำบลในอำเภอโนนไทย ผ่าน AI ที่เข้าใจรากเหง้าของชุมชน',
                    style: GoogleFonts.sarabun(
                        fontSize: isWide ? 15 : 13,
                        color: AppColors.textLight,
                        height: 1.9,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 12, runSpacing: 12,
                  children: [
                    _GoldButton(
                        label: 'สำรวจ 10 ชุมชน  →',
                        onTap: () => context.go(RouteConstants.explore)),
                    _GhostButton(label: 'เกี่ยวกับโครงการ', onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── STATS ─────────────────────────────────────────────────────────────────────
class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('10', 'ตำบล', 'อำเภอโนนไทย'),
      ('120+', 'เรื่องเล่า', 'บันทึกแล้ว'),
      ('75', 'ประวัติปากเปล่า', 'เสียงบรรยาย'),
      ('60', 'วิดีโอสัมภาษณ์', 'ชั่วโมงบันทึก'),
      ('340+', 'รูปภาพ', 'คลังภาพชุมชน'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.brownMid,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.gold.withOpacity(0.18)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 32,
        children: items
            .map((s) => SizedBox(
                  width: 150,
                  child: Column(children: [
                    Container(width: 1, height: 20,
                        color: AppColors.gold),
                    const SizedBox(height: 12),
                    Text(s.$1,
                        style: GoogleFonts.notoSerifThai(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldLight,
                            height: 0.9,
                            shadows: [
                              Shadow(
                                  color: AppColors.goldLight.withOpacity(0.28),
                                  blurRadius: 40)
                            ])),
                    const SizedBox(height: 8),
                    Text(s.$2,
                        style: GoogleFonts.sarabun(
                            fontSize: 13,
                            color: AppColors.cream,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(s.$3,
                        style: GoogleFonts.sarabun(
                            fontSize: 10,
                            color: AppColors.textMuted,
                            letterSpacing: 1.2)),
                  ]),
                ))
            .toList(),
      ),
    );
  }
}

// ─── BUTTONS ───────────────────────────────────────────────────────────────────
class _GoldButton extends StatelessWidget {
  const _GoldButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.gold, AppColors.goldLight]),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                  color: AppColors.gold.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Text(label,
              style: GoogleFonts.sarabun(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brownDark,
                  letterSpacing: 0.5)),
        ),
      );
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.38),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: AppColors.cream.withOpacity(0.3)),
          ),
          child: Text(label,
              style: GoogleFonts.sarabun(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.cream,
                  letterSpacing: 0.5)),
        ),
      );
}
