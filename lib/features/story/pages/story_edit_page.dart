import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suebsaiyai/application/story/story_editor_notifier.dart'; // 👈 เรียกใช้งาน Notifier
import 'package:suebsaiyai/core/theme/app_colors.dart';

class StoryEditPage extends ConsumerWidget {
  const StoryEditPage({super.key, required this.storyId});
  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 👈 แก้ไข: เรียกใช้นามธรรมจัดสรรข้อมูลผ่านตัวแปรที่แท้จริงแทนของเดิมที่ขาดหายไป
    final dynamic editorState = ref.watch(storyEditorNotifierProvider);
    final editorNotifier = ref.read(storyEditorNotifierProvider.notifier);

    final bool isLoading = editorState.isLoading == true;
    final String? errorMessage = editorState.errorMessage as String?;
    final String title = editorState.title?.toString() ?? '';
    final String content = editorState.content?.toString() ?? '';

    return Scaffold(
      backgroundColor: AppColors.brownDark,
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลเรื่องเล่า'),
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: (title.isNotEmpty && content.isNotEmpty)
                  ? () async {
                      final success = await editorNotifier.saveStory(storyId: storyId);
                      if (context.mounted && success) {
                        context.pop();
                      }
                    }
                  : null,
              child: Text(
                'อัปเดต',
                style: GoogleFonts.sarabun(
                  color: (title.isNotEmpty && content.isNotEmpty)
                      ? AppColors.goldLight
                      : AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.bottom(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: GoogleFonts.sarabun(color: AppColors.error, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                TextFormField(
                  initialValue: title,
                  style: GoogleFonts.notoSerifThai(fontSize: 22, color: AppColors.cream, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'ชื่อเรื่องเล่าภูมิปัญญา...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (val) => editorNotifier.updateTitle(val),
                ),
                const Divider(color: AppColors.gold, thickness: 0.5, height: 24),
                TextFormField(
                  initialValue: content,
                  maxLines: null,
                  style: GoogleFonts.sarabun(fontSize: 16, color: AppColors.textLight, height: 1.6),
                  decoration: const InputDecoration(
                    hintText: 'เนื้อหาภูมิปัญญาท้องถิ่น...',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (val) => editorNotifier.updateContent(val),
                ),
              ],
            ),
          ),
          if (isLoading)
            const Positioned.fill(
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
