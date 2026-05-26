import 'package:equatable/equatable.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';

enum EditorMode { create, edit }

class StoryEditorState extends Equatable {
  const StoryEditorState({
    this.story,
    this.mode = EditorMode.create,
    this.isSaving = false,
    this.isDirty = false,
    this.errorMessage,
    this.successMessage,
  });

  final StoryEntity? story;
  final EditorMode mode;
  final bool isSaving;
  final bool isDirty;
  final String? errorMessage;
  final String? successMessage;

  StoryEditorState copyWith({
    StoryEntity? story,
    EditorMode? mode,
    bool? isSaving,
    bool? isDirty,
    String? errorMessage,
    String? successMessage,
  }) =>
      StoryEditorState(
        story: story ?? this.story,
        mode: mode ?? this.mode,
        isSaving: isSaving ?? this.isSaving,
        isDirty: isDirty ?? this.isDirty,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );

  @override
  List<Object?> get props => [story, mode, isSaving, isDirty, errorMessage, successMessage];
}
