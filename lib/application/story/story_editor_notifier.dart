import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/auth/auth_notifier.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/application/story/story_editor_state.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';
import 'package:suebsaiyai/domain/enums/story_status.dart';
import 'package:suebsaiyai/domain/repositories/story_repository.dart';

class StoryEditorNotifier extends StateNotifier<StoryEditorState> {
  StoryEditorNotifier(
    this._repo, {
    this.authorId = '',
    this.districtId = '',
  }) : super(const StoryEditorState());

  final StoryRepository _repo;
  final String authorId;
  final String districtId;

  void updateTitle(String title) {
    state = state.copyWith(title: title, isDirty: true);
  }

  void updateContent(String content) {
    state = state.copyWith(content: content, isDirty: true);
  }

  void loadStory(StoryEntity story) {
    state = state.copyWith(
      story: story,
      title: story.title,
      content: story.content,
      mode: EditorMode.edit,
    );
  }

  Future<bool> saveStory({String? storyId}) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    final now = DateTime.now();

    if (storyId != null) {
      final getResult = await _repo.getStory(storyId);
      final existingStory = getResult.fold((_) => null, (s) => s);
      if (existingStory == null) {
        state = state.copyWith(isSaving: false, errorMessage: 'ไม่พบเรื่องเล่า');
        return false;
      }
      final updated = existingStory.copyWith(
        title: state.title,
        content: state.content,
        updatedAt: now,
      );
      final result = await _repo.updateStory(updated);
      return result.fold((f) {
        state = state.copyWith(isSaving: false, errorMessage: f.message);
        return false;
      }, (_) {
        state = state.copyWith(isSaving: false, isDirty: false, successMessage: 'บันทึกสำเร็จ');
        return true;
      });
    } else {
      final newStory = StoryEntity(
        id: '',
        title: state.title,
        content: state.content,
        authorId: authorId,
        districtId: districtId,
        status: StoryStatus.draft,
        createdAt: now,
        updatedAt: now,
      );
      final result = await _repo.createStory(newStory);
      return result.fold((f) {
        state = state.copyWith(isSaving: false, errorMessage: f.message);
        return false;
      }, (story) {
        state = state.copyWith(isSaving: false, story: story, isDirty: false);
        return true;
      });
    }
  }
}

final storyEditorNotifierProvider =
    StateNotifierProvider.autoDispose<StoryEditorNotifier, StoryEditorState>((ref) {
  final user = ref.watch(currentUserProvider);
  return StoryEditorNotifier(
    ref.watch(storyRepositoryProvider),
    authorId: user?.uid ?? '',
    districtId: user?.districtId ?? '',
  );
});
