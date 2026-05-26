import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/application/story/story_editor_state.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';
import 'package:suebsaiyai/domain/repositories/story_repository.dart';

class StoryEditorNotifier extends StateNotifier<StoryEditorState> {
  StoryEditorNotifier(this._repo, this._ref) : super(const StoryEditorState());
  final StoryRepository _repo;
  final Ref _ref;

  void initCreate() => state = const StoryEditorState(mode: EditorMode.create);

  void initEdit(StoryEntity story) => state = StoryEditorState(story: story, mode: EditorMode.edit);

  void markDirty() => state = state.copyWith(isDirty: true);

  Future<bool> save({
    required String title,
    required String content,
    List<String>? tags,
  }) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return false;

    state = state.copyWith(isSaving: true, errorMessage: null);

    final now = DateTime.now();
    final story = state.story?.copyWith(
          title: title,
          content: content,
          tags: tags ?? state.story?.tags ?? [],
          updatedAt: now,
        ) ??
        StoryEntity(
          id: '',
          title: title,
          content: content,
          authorId: user.uid,
          authorName: user.displayName,
          districtId: user.districtId,
          status: StoryStatus.draft,
          createdAt: now,
          updatedAt: now,
          tags: tags ?? [],
        );

    final result = state.mode == EditorMode.create
        ? await _repo.createStory(story)
        : await _repo.updateStory(story);

    return result.fold(
      (f) {
        state = state.copyWith(isSaving: false, errorMessage: f.message);
        return false;
      },
      (saved) {
        state = state.copyWith(story: saved, isSaving: false, isDirty: false, successMessage: 'บันทึกแล้ว');
        return true;
      },
    );
  }

  Future<bool> submit() async {
    if (state.story == null) return false;
    state = state.copyWith(isSaving: true);
    final result = await _repo.transitionStatus(state.story!.id, StoryStatus.submitted);
    return result.fold(
      (f) {
        state = state.copyWith(isSaving: false, errorMessage: f.message);
        return false;
      },
      (updated) {
        state = state.copyWith(story: updated, isSaving: false, successMessage: 'ส่งสำเร็จ');
        return true;
      },
    );
  }
}

final storyEditorProvider = StateNotifierProvider.autoDispose<StoryEditorNotifier, StoryEditorState>(
  (ref) => StoryEditorNotifier(ref.watch(storyRepositoryProvider), ref),
);
