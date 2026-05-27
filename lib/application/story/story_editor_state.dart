import 'package:equatable/equatable.dart';
import 'package:suebsaiyai/domain/entities/story_entity.dart';

enum EditorMode { create, edit }

class StoryEditorState extends Equatable {
  const StoryEditorState({
    this.story,
    this.mode = EditorMode.create,
    this.isSaving = false,
    this.isDirty = false,
    this.title = '',
    this.content = '',
    this.errorMessage,
    this.successMessage,
  });

  final StoryEntity? story;
  final EditorMode mode;
  final bool isSaving;
  final bool isDirty;
  final String title;
  final String content;
  final String? errorMessage;
  final String? successMessage;

  StoryEditorState copyWith({
    StoryEntity? story,
    EditorMode? mode,
    bool? isSaving,
    bool? isDirty,
    String? title,
    String? content,
    String? errorMessage,
    String? successMessage,
  }) =>
      StoryEditorState(
        story: story ?? this.story,
        mode: mode ?? this.mode,
        isSaving: isSaving ?? this.isSaving,
        isDirty: isDirty ?? this.isDirty,
        title: title ?? this.title,
        content: content ?? this.content,
        errorMessage: errorMessage,
        successMessage: successMessage,
      );

  @override
  List<Object?> get props =>
      [story, mode, isSaving, isDirty, title, content, errorMessage, successMessage];
}
