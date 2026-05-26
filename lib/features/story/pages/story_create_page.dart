import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:suebsaiyai/application/story/story_editor_notifier.dart';
import 'package:suebsaiyai/application/story/story_editor_state.dart';
import 'package:suebsaiyai/core/constants/route_constants.dart';
import 'package:suebsaiyai/core/utils/validators.dart';

class StoryCreatePage extends ConsumerStatefulWidget {
  const StoryCreatePage({super.key});

  @override
  ConsumerState<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends ConsumerState<StoryCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(storyEditorProvider.notifier).initCreate());
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final tags = _tagsCtrl.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
    final success = await ref.read(storyEditorProvider.notifier).save(title: _titleCtrl.text.trim(), content: _contentCtrl.text, tags: tags);
    if (success && mounted) context.go(RouteConstants.myStories);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storyEditorProvider);
    final isSaving = state.isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มเรื่องใหม่'),
        actions: [
          if (isSaving) const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: CircularProgressIndicator(strokeWidth: 2))
          else TextButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('บันทึก')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'ชื่อเรื่อง *'), validator: Validators.storyTitle, onChanged: (_) => ref.read(storyEditorProvider.notifier).markDirty()),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentCtrl,
                decoration: const InputDecoration(labelText: 'เนื้อหา *', alignLabelWithHint: true),
                maxLines: 20,
                validator: Validators.storyContent,
                onChanged: (_) => ref.read(storyEditorProvider.notifier).markDirty(),
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _tagsCtrl, decoration: const InputDecoration(labelText: 'แท็ก (คั่นด้วย ,)', hintText: 'เช่น ประเพณี, อาหาร, ภูมิปัญญา')),
              const SizedBox(height: 24),
              if (state.errorMessage != null) ...[
                Card(color: Colors.red.shade50, child: Padding(padding: const EdgeInsets.all(12), child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)))),
                const SizedBox(height: 16),
              ],
              FilledButton.icon(
                onPressed: isSaving ? null : _save,
                icon: const Icon(Icons.save),
                label: const Text('บันทึกร่าง'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
