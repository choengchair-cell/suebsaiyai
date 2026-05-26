import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/application/story/story_editor_notifier.dart';
import 'package:suebsaiyai/application/story/story_editor_state.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/core/utils/validators.dart';

class StoryEditPage extends ConsumerStatefulWidget {
  const StoryEditPage({super.key, required this.storyId});
  final String storyId;

  @override
  ConsumerState<StoryEditPage> createState() => _StoryEditPageState();
}

class _StoryEditPageState extends ConsumerState<StoryEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;
    final result = await ref.read(storyRepositoryProvider).getStory(widget.storyId);
    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message))),
      (story) {
        ref.read(storyEditorProvider.notifier).initEdit(story);
        _titleCtrl.text = story.title;
        _contentCtrl.text = story.content;
      },
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref.read(storyEditorProvider.notifier).save(title: _titleCtrl.text.trim(), content: _contentCtrl.text);
    if (success && mounted) context.go(RouteConstants.myStories);
  }

  @override
  Widget build(BuildContext context) {
    _init();
    final state = ref.watch(storyEditorProvider);
    final isSaving = state.isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขเรื่อง'),
        actions: [
          if (!isSaving) TextButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('บันทึก')),
        ],
      ),
      body: state.isSaving && state.story == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'ชื่อเรื่อง *'), validator: Validators.storyTitle),
                    const SizedBox(height: 16),
                    TextFormField(controller: _contentCtrl, decoration: const InputDecoration(labelText: 'เนื้อหา *', alignLabelWithHint: true), maxLines: 20, validator: Validators.storyContent),
                    const SizedBox(height: 24),
                    FilledButton(onPressed: isSaving ? null : _save, child: isSaving ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white) : const Text('บันทึก')),
                  ],
                ),
              ),
            ),
    );
  }
}
